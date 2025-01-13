module Door (
    input clk_2Hz,          
    input reset,            
    input open_signal,      
    output reg DoorLED          
);

    reg [4:0] counter;  // 5-bit counter for 20 cycles (10 seconds)
    reg latch;          

    always @(posedge clk_2Hz or negedge reset) begin
        if (~reset) begin
            counter <= 5'b00000;  
            latch <= 1'b0;    
            DoorLED <= 1'b0;       
        end
        else if (latch) begin
			if (counter < 5'b10100) begin
				counter <= counter + 1; 
				DoorLED <= ~DoorLED;            
			end
			else begin
				latch <= 1'b0;          
				DoorLED <= 1'b0; 
				counter <= 5'b00000;           
			end
        end
			
		else if (open_signal) begin
			latch <= 1'b1;
		end
    end
endmodule
