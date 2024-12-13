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