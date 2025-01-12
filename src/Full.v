module Full (
    input clk_1Hz,          
    input reset,            
    input full_signal,      
    output reg fullLED        
);

    reg [2:0] counter; // 3-bit counter for 6 cycles (3 on/off periods)
    reg latch;         

    always @(posedge clk_1Hz or negedge reset) begin
        if (~reset) begin
            counter <= 3'b000;  
            latch <= 1'b0;    
            fullLED <= 1'b0;      
        end

        else if (latch) begin
            if (counter < 3'b110) begin
                counter <= counter + 1; 
                fullLED <= ~fullLED;            
            end
            else begin
                latch <= 1'b0;          
                fullLED <= 1'b0;
                counter <= 3'b000;  
            end
        end
		
		else if (full_signal) begin
            latch <= 1'b1;
        end
    end

endmodule
