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
