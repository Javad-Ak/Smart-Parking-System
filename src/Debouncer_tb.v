module Debouncer_tb;
    reg clk;
    reg inButton;
    reg reset;
    wire outButton;

    Debouncer uut(.clk(clk), .inButton(inButton), .outButton(outButton), .reset(reset));

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, Debouncer_tb);
        reset = 1;
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
