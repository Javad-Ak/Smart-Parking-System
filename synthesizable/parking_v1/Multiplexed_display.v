module Multiplexed_display (
    input clk_500Hz,                  
    input reset,                
    input [2:0] empty_slot,     
    input [2:0] capacity,       
    output reg [4:0] SEG_SEL,   
    output reg [7:0] SEG_DATA   
);
    reg display_select;   
      
    always @(posedge clk_500Hz or negedge reset) begin
        if (~reset) begin
            SEG_SEL <= 5'b00000;
            SEG_DATA <= 8'b00000000;
            display_select <= 1'b0;
        end else begin
            display_select <= ~display_select;

            if (display_select == 1'b0) begin
                // Display empty_slot
                SEG_SEL <= 5'b00010;
                case (empty_slot)
                    3'b000: SEG_DATA <= 8'b00111111; // Display 0
                    3'b001: SEG_DATA <= 8'b00000110; // Display 1
                    3'b010: SEG_DATA <= 8'b01011011; // Display 2
                    3'b011: SEG_DATA <= 8'b01001111; // Display 3
                    default: SEG_DATA <= 8'b01000000; // Blank display
                endcase
            end else begin
                // Display capacity
                SEG_SEL <= 5'b01000; // Enable capacity and colon
                case (capacity)
                    3'b000: SEG_DATA <= 8'b00111111; // Display 0
                    3'b001: SEG_DATA <= 8'b00000110; // Display 1
                    3'b010: SEG_DATA <= 8'b01011011; // Display 2
                    3'b011: SEG_DATA <= 8'b01001111; // Display 3
                    3'b100: SEG_DATA <= 8'b01100110; // Display 4
                    3'b101: SEG_DATA <= 8'b01101101; // Display 5
                    3'b110: SEG_DATA <= 8'b01111101; // Display 6
                    3'b111: SEG_DATA <= 8'b00000111; // Display 7
                    default: SEG_DATA <= 8'b01000000; // Blank display
                endcase
            end
        end
    end
endmodule
