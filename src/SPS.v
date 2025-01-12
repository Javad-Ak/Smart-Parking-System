
module SPS(
    input clk,                  // Clock signal
    input reset_in,             // Reset signal (active low)
    input entry_signal_in,      // Signal when a car enters
    input exit_signal_in,       // Signal when a exits
    input [1:0] exit_slot_in,   // Selects exiting spot
    output [4:0] SEG_SEL,       // Enable lines for 5 digits
    output [7:0] SEG_DATA,      // 7-segment control lines (a to g)
    output [3:0] spots,         // Occupied spots
    output doorLED,             // is_open LED
    output fullLED              // is_full LED
);

wire is_open;
wire is_full;
wire [2:0] capacity;
wire [2:0] location;

wire [5:0] minutes;
wire [5:0] seconds;

wire entry_signal;    
wire exit_signal;   
wire [1:0] exit_slot;   

Debouncer d2(.clk(clk), .inButton(~entry_signal_in), .outButton(entry_signal), .reset(reset_in));
Debouncer d3(.clk(clk), .inButton(~exit_signal_in), .outButton(exit_signal), .reset(reset_in));

wire clk_2Hz;
wire clk_1Hz;
wire clk_500Hz;

FreqDiv m1 (.clk(clk), .reset(reset_in), .clk_500Hz(clk_500Hz), .clk_1Hz(clk_1Hz), .clk_2Hz(clk_2Hz));

FSM m2 (
	.clk(clk),
    .reset(reset_in), // Active-low reset
    .entry_signal(entry_signal),
    .exit_signal(exit_signal),
    .exit_slot(exit_slot_in),
    .is_open(is_open),
    .is_full(is_full),
    .spots(spots),
    .capacity(capacity),
    .location(location)
);

Full m3 (
    .clk_1Hz(clk_1Hz),
    .reset(reset_in),
    .full_signal(is_full),
    .fullLED(fullLED)
);

Door m4 (
    .clk_2Hz(clk_2Hz),
    .reset(reset_in),
    .open_signal(is_open),
    .DoorLED(doorLED)
);

Multiplexed_display uut (
    .clk_500Hz(clk_500Hz),
    .reset(reset_in),
    .capacity(capacity),
    .empty_slot(location),
    .SEG_SEL(SEG_SEL),
    .SEG_DATA(SEG_DATA)
);
endmodule
