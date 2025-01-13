module FreqDiv_tb;
    reg clk;
    reg reset;
    wire clk_2Hz;
    wire clk_1Hz;
    wire clk_500Hz;

    FreqDiv uut (.clk(clk), .reset(reset), .clk_500Hz(clk_500Hz), .clk_1Hz(clk_1Hz), .clk_2Hz(clk_2Hz));

    initial begin
        $dumpfile("Frtest.vcd");
        $dumpvars(0, clk_1Hz, clk_2Hz, clk_500Hz);
        clk = 0;
        reset = 0; 
        #50 reset = 1;
        #1_000_000_000;
        $finish;
    end


    always #12.5 clk = ~clk;

endmodule
