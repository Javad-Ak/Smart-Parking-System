module Multiplexed_display (
    input mode,
    input [3:0] timer_01,
	 input [3:0] timer_02,
    input clk_500Hz,                  
    input reset,                
    input [2:0] empty_slot,     
    input [2:0] capacity,       
    output reg [4:0] SEG_SEL,   
    output reg [7:0] SEG_DATA   
);
    reg display_select;   
    
    reg [3:0] dig1;
    reg [3:0] dig2;

    always @(posedge clk_500Hz or negedge reset) begin
        if (~reset) begin
            dig1 = 0;
            dig2 = 0;
            SEG_SEL <= 5'b00000;
            SEG_DATA <= 8'b00000000;
            display_select <= 1'b0;
        end else begin
            display_select <= ~display_select;
            
            if (mode) begin
                dig1 = timer_02;
                dig2 = timer_01;
            end
            else begin
                dig1 = capacity;
                dig2 = empty_slot;
            end

            if (display_select == 1'b0) begin
                // Display empty_slot
                SEG_SEL <= 5'b00100;
                case (dig1)
                    4'b0000: SEG_DATA <= 8'b00111111; // Display 0
                    4'b0001: SEG_DATA <= 8'b00000110; // Display 1
                    4'b0010: SEG_DATA <= 8'b01011011; // Display 2
                    4'b0011: SEG_DATA <= 8'b01001111; // Display 3
                    4'b0100: SEG_DATA <= 8'b01100110; // Display 4
                    4'b0101: SEG_DATA <= 8'b01101101; // Display 5
                    4'b0110: SEG_DATA <= 8'b01111101; // Display 6
                    4'b0111: SEG_DATA <= 8'b00000111; // Display 7
                    4'b1000: SEG_DATA <= 8'b01111111; // Display 8
                    4'b1001: SEG_DATA <= 8'b01101111; // Display 9
                    default: SEG_DATA <= 8'b01000000; // Blank display
                endcase
            end else begin
                // Display capacity
                SEG_SEL <= 5'b00010; // Enable capacity and colon
                case (dig2)
                    4'b0000: SEG_DATA <= 8'b00111111; // Display 0
                    4'b0001: SEG_DATA <= 8'b00000110; // Display 1
                    4'b0010: SEG_DATA <= 8'b01011011; // Display 2
                    4'b0011: SEG_DATA <= 8'b01001111; // Display 3
                    4'b0100: SEG_DATA <= 8'b01100110; // Display 4
                    4'b0101: SEG_DATA <= 8'b01101101; // Display 5
                    4'b0110: SEG_DATA <= 8'b01111101; // Display 6
                    4'b0111: SEG_DATA <= 8'b00000111; // Display 7
                    4'b1000: SEG_DATA <= 8'b01111111; // Display 8
                    4'b1001: SEG_DATA <= 8'b01101111; // Display 9
                    default: SEG_DATA <= 8'b01000000; // Blank display
                endcase
            end
				
				if (~mode && empty_slot == 7 && display_select) begin
					SEG_DATA <= 8'b01000000;
				end
				
				if (mode == 0 && ~display_select) SEG_DATA[7] <= 1;
				
        end
    end
endmodule
