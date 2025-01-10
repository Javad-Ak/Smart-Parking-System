

// This module is designed in order to stabilize the input
// if the input change for a short time the output doesn't change
// if the input doesn't change for 1_000_000 clock it appears in output

`timescale 1ns / 1ps
module Debouncer
  (
   input clk,     
   input reset, 
   input inButton,  
   output reg outButton 
   );

  parameter CLK_FREQUENCY = 40_000_000,
  DEBOUNCE_HZ = 2

  localparam COUNT_VALUE = CLK_FREQUENCY / DEBOUNCE_HZ;
  reg [1:0] state;
  reg [25:0] count;
  reg button_sync, button_sync_prev;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state <= 0;
      outButton <= 0;
      count <= 0;
      button_sync <= 0;
      button_sync_prev <= 0;
    end else begin
      button_sync <= inButton;
      button_sync_prev <= button_sync;
      outButton <= 0;

      case (state)
        0: begin
          if (button_sync && !button_sync_prev) begin // rising
            state <= 1;
            count <= 0;
          end
        end
        1: begin
          if (count < COUNT_VALUE - 1) begin
            count <= count + 1;
          end else begin
            outButton <= 1; // pulse
            state <= 0;
          end
        end
      endcase
    end
  end
 endmodule



module Door (
    input clk_2Hz,          
    input reset,            
    input open_signal,      
    output reg DoorLED          
);

    reg [4:0] counter = 5'd0;  // 5-bit counter for 20 cycles (10 seconds)
    reg latch = 1'b0;          
    always @ (open_signal) begin
        latch = 1;
    end 
    always @(posedge clk_2Hz or reset) begin
        if (~reset) begin
            counter = 5'd0;  
            latch = 1'b0;    
            DoorLED = 1'b0;       
        end
        else begin
            
            if (latch) begin
                if (counter < 5'd20) begin
                    counter = counter + 1; 
                    DoorLED = ~DoorLED;            
                end
                else begin
                    latch = 1'b0;          
                    DoorLED = 1'b0; 
                    counter = 1'b0;           
                end
            end
        end
    end

endmodule




module FreqDiv(input clk,
               input reset,
               output reg clk_500Hz,
               output reg clk_1Hz,
               output reg clk_2Hz);
    reg [16:0] counter_500Hz;
    reg [24:0] counter_2Hz;
    reg [25:0] counter_1Hz;

    always @ (posedge clk or reset) begin
        if (~reset) begin
            counter_500Hz=0;
            counter_2Hz=0;
            counter_1Hz=0;
            clk_2Hz=0;
            clk_1Hz=0;
            clk_500Hz=0;
        end

        else begin
            if (counter_2Hz == 10_000_000 - 1) begin
                counter_2Hz = 0;
                clk_2Hz = ~clk_2Hz;
            end
            else begin
                counter_2Hz = counter_2Hz + 1;
            end
            if (counter_1Hz == 20_000_000 - 1) begin
                counter_1Hz = 0;
                clk_1Hz = ~clk_1Hz;
            end
            else begin
                counter_1Hz = counter_1Hz + 1;
            end
            if (counter_500Hz == 40_000 - 1) begin
                counter_500Hz = 0;
                clk_500Hz = ~clk_500Hz;
            end
            else begin
                counter_500Hz = counter_500Hz + 1;
            end
        end
    end
endmodule




module FSM(
    input clk,                // Clock signal
    input reset,              // Reset signal (active low)
    input entry_signal,       // Signal when a car enters
    input exit_signal,        // Signal when a exits
    input [1:0] exit_slot,    // Selects exiting spot
    output reg is_open,       // Signal to open the door
    output reg is_full,       // Signal when parking is full
    output reg [3:0] spots,   // Occupied spots
    output reg [2:0] capacity,// Current remaining capacity
    output reg [1:0] location // First available empty slot
);
    // Parameters for states based on remaining capacity
    parameter S4 = 3'b100;  // 4 slots remaining (Idle)
    parameter S3 = 3'b011;  // 3 slots remaining
    parameter S2 = 3'b010;  // 2 slots remaining
    parameter S1 = 3'b001;  // 1 slot remaining
    parameter S0 = 3'b000;  // 0 slots remaining (Full)

    // State change logic
    always @(posedge clk or reset) begin
    if (~reset) begin
    capacity = S4;
    spots = 4'b0000;     // All spots are free (0 = free, 1 = full)
    is_full = 0;
    is_open = 0;
    location = 2'b00;    // Default to the first slot

    end else begin    
    // Door handling
    is_full = 0;
    is_open = 0;
    if (entry_signal) begin
        if (capacity==S0) is_full = 1;
        else is_open = 1;
    end 
    if (exit_signal && (spots[exit_slot])) is_open = 1;
     
    // Find the first available spot
    location = 2'bzz;
    if (spots[0] == 1'b0) location = 2'b00;
    else if (spots[1] == 1'b0) location = 2'b01;
    else if (spots[2] == 1'b0) location = 2'b10;
    else if (spots[3] == 1'b0) location = 2'b11;

    // Parking management logic
    case (capacity)
        S3, S2, S1: begin
        if (entry_signal) begin
            // fill the spot
            spots[location] = 1'b1;
            capacity--;
        end
        if (exit_signal && spots[exit_slot]) begin
            // Free the selected spot
            spots[exit_slot] = 1'b0;
            capacity++;
        end
        end
            
        S4: begin
            if (entry_signal) begin
                // fill the first spot
                spots[0] = 1'b1;
                capacity--;
            end
        end
            
        S0: begin
            if (exit_signal) begin
                // Free the selected spot
                spots[exit_slot] = 1'b0;
                capacity++;
            end
        end
    endcase  

    end
    end
	 
endmodule




module Full (
    input clk_1Hz,          
    input reset,            
    input full_signal,      
    output reg fullLED        
);

    reg [2:0] counter = 3'd0; // 3-bit counter for 6 cycles (3 on/off periods)
    reg latch = 1'b0;         
    always @(full_signal) begin
        latch = 1;
    end
    always @(posedge clk_1Hz or reset) begin
        if (~reset) begin
            counter = 3'd0;  
            latch = 1'b0;    
            fullLED = 1'b0;      
        end
        else begin

            if (latch) begin
                if (counter < 3'd6) begin
                    counter <= counter + 1; 
                    fullLED = ~fullLED;            
                end
                else begin
                    latch = 1'b0;          
                    fullLED = 1'b0;
                    counter = 1'b0;  
                end
            end
        end
    end

endmodule




module Multiplexed_display (
    input clk_500Hz,    
    input reset,                
    input mode,         
    input [2:0] capacity,     
    input [1:0] empty_slot,   
    input [5:0] minutes,      
    input [5:0] seconds,      
    output reg [6:0] seg,          
    output reg [3:0] anode,
    output reg colon         
);

    reg [3:0] digit;             // Current digit to display
    reg [1:0] digit_select;      // Digit selector (0-3)

    // 7-segment decoder
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b0000001; // 0
            4'd1: seg = 7'b1001111; // 1
            4'd2: seg = 7'b0010010; // 2
            4'd3: seg = 7'b0000110; // 3
            4'd4: seg = 7'b1001100; // 4
            4'd5: seg = 7'b0100100; // 5
            4'd6: seg = 7'b0100000; // 6
            4'd7: seg = 7'b0001111; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0000100; // 9
            default: seg = 7'b1111111; // Blank (all segments off)
        endcase
    end

    // Multiplexing logic
    always @(posedge clk_500Hz or reset) begin
        if (~reset) begin
            digit_select = 0;
            anode = 4'b1111;  // Turn off all digits
        end else begin
            // Cycle through the four digits
            digit_select = digit_select + 1;
            anode = 4'b1111; // Turn off all digits
            case (digit_select)
                2'd0: anode = 4'b1110; // Activate first digit
                2'd1: anode = 4'b1101; // Activate second digit
                2'd2: anode = 4'b1011; // Activate third digit
                2'd3: anode = 4'b0111; // Activate fourth digit
            endcase
        end
    end

    // Determine which value to display
    always @(*) begin
        colon = (mode == 0) ? 1 : 0;
        case (digit_select)
            2'd0: digit = (mode == 0) ? capacity : (minutes / 10);    // capacity or tens of minutes
            2'd1: digit = (mode == 0) ? 4'd15 : (minutes % 10); // Blank or units of minutes
            2'd2: digit = (mode == 0) ? empty_slot : (seconds / 10);      // slots or tens of seconds
            2'd3: digit = (mode == 0) ? 4'd15 : (seconds % 10);      // Blank (4'd15) or units of seconds
        endcase
    end

endmodule




module ParkingDisplay (
    input clk_500Hz,          // 500 Hz clock input
    input reset,              // Reset signal
    input [2:0] capacity,     // Number of free slots (0–4)
    input [1:0] first_empty,  // First empty slot (0–3)
    output reg [1:0] anodes,  // Enable lines for 2 digits
    output reg [6:0] segments // 7-segment control lines (a to g)
);

    reg digit_select; // 1-bit counter for digit selection (0 or 1)

    // Segment decoding logic for one digit (7 segments)
    function [6:0] decode_segments(input [3:0] value);
        case (value)
            4'd0: decode_segments = 7'b1000000; // Display 0
            4'd1: decode_segments = 7'b1111001; // Display 1
            4'd2: decode_segments = 7'b0100100; // Display 2
            4'd3: decode_segments = 7'b0110000; // Display 3
            4'd4: decode_segments = 7'b0011001; // Display 4
            default: decode_segments = 7'b1111111; // Blank (all OFF)
        endcase
    endfunction

    // Digit selection logic
    always @(posedge clk_500Hz or reset) begin
        if (~reset) begin
            digit_select = 1'b0; // Reset to first digit
        end else begin
            digit_select = ~digit_select; // Toggle between 0 and 1
        end
    end

    // Anode enable and segment control logic
    always @(*) begin
        case (digit_select)
            1'b0: begin
                anodes = 2'b10;                      // Enable left digit (Capacity)
                segments = decode_segments(capacity); // Decode capacity
            end
            1'b1: begin
                anodes = 2'b01;                      // Enable right digit (First Empty Slot)
                segments = decode_segments(first_empty); // Decode first empty slot
            end
        endcase
    end

endmodule




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


