module Door_tb;
    reg clk_2Hz;
    reg reset;
    reg open_signal;
    wire DoorLED;

    Door uut (
        .clk_2Hz(clk_2Hz),
        .reset(reset),
        .open_signal(open_signal),
        .DoorLED(DoorLED)
    );

    initial begin

        $dumpfile("Doortest.vcd");
        $dumpvars(0, Door_tb);

        clk_2Hz = 0;
        reset = 0; open_signal = 0; #50; 

        reset = 1; open_signal = 1; #20;
        open_signal = 0; #300; 

        $finish;
    end

    always #10 clk_2Hz = ~clk_2Hz;
endmodule
