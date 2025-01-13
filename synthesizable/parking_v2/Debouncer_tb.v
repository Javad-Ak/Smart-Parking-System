
`timescale 1ns/1ps

// important: set (parameter COUNT_VALUE = 2) before testing
module Debouncer_tb;
    reg clk;             // 40 MHz clock signal
    reg reset;           // Reset signal
    reg inButton;        // Noisy button input signal
    wire outButton;      // Debounced output signal

    // Instantiate the debouncer module
    Debouncer uut (
        .clk(clk),
        .reset(reset),
        .inButton(inButton),
        .outButton(outButton)
    );

    // Clock generation: Generate a 40 MHz clock (period = 25ns)
    always #12.5 clk = ~clk;  // 40 MHz clock

    // Test sequence
    initial begin
        clk = 0;
        reset = 0;
        inButton = 0;

        #100 reset = 1;
        inButton = 1;   
        
        #1000 $finish;
    end

endmodule
