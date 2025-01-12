module Debouncer(
    input clk,       
    input reset, // active low   
    input inButton,  
    output reg outButton 
);

    parameter COUNT_VALUE = 20000000; // 40 MHz clk
    reg [1:0] state;
    reg [25:0] count;
    reg button_sync, button_sync_prev;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
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
                2'b00: begin
                    if (button_sync && !button_sync_prev) begin // rising edge
                        state <= 2'b01;
                        count <= 26'b0;
                    end
                end
                2'b01: begin
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
