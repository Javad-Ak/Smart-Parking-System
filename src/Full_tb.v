module Full_tb;
    reg clk_1Hz;
    reg reset;
    reg full_signal;
    wire fullLED;

    Full uut (
        .clk_1Hz(clk_1Hz),
        .reset(reset),
        .full_signal(full_signal),
        .fullLED(fullLED)
    );


    initial begin
        
        $dumpfile("Fulltest.vcd");
        $dumpvars(0, Full_tb);

        clk_1Hz = 0;
        reset = 0; full_signal = 0; #50; 

        reset = 1; full_signal = 1; #10; 
        full_signal = 0; #600;  

        $finish;
    end

    always #10 clk_1Hz = ~clk_1Hz;
endmodule