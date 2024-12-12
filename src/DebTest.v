`timescale 1ns/1ps

module DebTest;
    reg clk;
    reg inButton;
    wire outButton;

    debouncer uut(.clk(clk), .inButton(inButton), .outButton(outButton));

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, DebTest);
        clk = 0;
        inButton = 0;
        #15 inButton = 1;
        #10 inButton = 0;
        #10 inButton = 1;
        #100 inButton = 1;
        #200 $finish;
    end

    always #5 clk = ~clk;



endmodule