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
