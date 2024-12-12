`timescale 1ns/1ps

module FreqTest;
    reg clk;
    reg reset;
    wire clk_2Hz;
    wire clk_1Hz;

    FreqDiv uut (.clk(clk), .reset(reset), .clk_1Hz(clk_1Hz), .clk_2Hz(clk_2Hz));

    initial begin
        $dumpfile("Frtest.vcd");
        $dumpvars(0, FreqTest);
        clk = 0;
        reset = 1; 
        #50 reset = 0;
        #200;
        $finish;
    end


    always #12.5 clk = ~clk;

endmodule