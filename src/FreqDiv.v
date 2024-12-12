module FreqDiv(input clk,
               input reset,
               output reg clk_1Hz,
               output reg clk_2Hz);
    reg [24:0] counter_2Hz;
    reg [25:0] counter_1Hz;

    initial begin 
        counter_2Hz=0;
        counter_1Hz=0;
        clk_2Hz=0;
        clk_1Hz=0;
    end

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            counter_2Hz=0;
            counter_1Hz=0;
            clk_2Hz=0;
            clk_1Hz=0;
        end

        else begin
            if (counter_2Hz == 20_000_000 - 1) begin
                counter_2Hz = 0;
                clk_2Hz = ~clk_2Hz;
            end
            else begin
                counter_2Hz = counter_2Hz + 1;
            end
            if (counter_1Hz == 40_000_000 - 1) begin
                counter_1Hz = 0;
                clk_1Hz = ~clk_1Hz;
            end
            else begin
                counter_1Hz = counter_1Hz + 1;
            end
        end
    end
endmodule