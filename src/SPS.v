module SPS(
    input clk,                  // Clock signal
    input reset_in,             // Reset signal (active low)
    input entry_signal_in,      // Signal when a car enters
    input exit_signal_in,       // Signal when a exits
    input [1:0] exit_slot_in,   // Selects exiting spot
    output [3:0] anode,         // Enable lines for 4 digits
    output [6:0] segments,      // 7-segment control lines (a to g)
    output colon,               // mode (0 for cap, 1 for time)
    output [3:0] spots,         // Occupied spots
    output doorLED,             // is_open LED
    output fullLED              // is_full LED
);

wire is_open;
wire is_full;
wire [2:0] capacity;
wire [1:0] location;

wire mode;
wire [5:0] minutes;
wire [5:0] seconds;

wire reset;            
wire entry_signal;    
wire exit_signal;   
wire [1:0] exit_slot;   

Debouncer d1(.clk(clk), .inButton(reset_in), .outButton(reset), .reset(reset));
Debouncer d2(.clk(clk), .inButton(entry_signal_in), .outButton(entry_signal), .reset(reset));
Debouncer d3(.clk(clk), .inButton(exit_signal_in), .outButton(exit_signal), .reset(reset));
Debouncer d4(.clk(clk), .inButton(exit_slot_in[0]), .outButton(exit_slot[0]), .reset(reset));
Debouncer d5(.clk(clk), .inButton(exit_slot_in[1]), .outButton(exit_slot[0], .reset(reset)));

FSM m1 (
    .clk(clk),
    .reset(reset), // Active-low reset
    .entry_signal(entry_signal),
    .exit_signal(exit_signal),
    .exit_slot(exit_slot),
    .is_open(is_open),
    .is_full(is_full),
    .spots(spots),
    .capacity(capacity),
    .location(location)
);

wire clk_2Hz;
wire clk_1Hz;
wire clk_500Hz;

FreqDiv m2 (.clk(clk), .reset(reset), .clk_500Hz(clk_500Hz), .clk_1Hz(clk_1Hz), .clk_2Hz(clk_2Hz));

Full m3 (
    .clk_1Hz(clk_1Hz),
    .reset(reset),
    .full_signal(is_full),
    .fullLED(fullLED)
);

Door m4 (
    .clk_2Hz(clk_2Hz),
    .reset(reset),
    .open_signal(is_open),
    .DoorLED(doorLED)
);

// ToDO: time logic must come from FSM (not assign)
assign
    mode = 1'b0,
    minutes = 6'b000000,
    seconds = 6'b000000;

Multiplexed_display uut (
    .clk_500Hz(clk_500Hz),
    .reset(reset),
    .mode(mode),
    .capacity(capacity),
    .empty_slot(location),
    .minutes(minutes),
    .seconds(seconds),
    .seg(segments),
    .anode(anode),
    .colon(colon)
);

endmodule
