
`timescale 1ns / 1ps

// important: set (parameter COUNT_VALUE = 2) before testing
module SPS_tb;

    // Inputs
    reg clk;
    reg reset_in;
    reg entry_signal_in;
    reg exit_signal_in;
    reg [1:0] exit_slot_in;

    // Outputs
    wire [4:0] SEG_SEL;
    wire [7:0] SEG_DATA;
    wire [3:0] spots;
    wire doorLED;
    wire fullLED;

    // Instantiate the Unit Under Test (UUT)
    SPS uut (
        .clk(clk),
        .reset_in(reset_in),
        .entry_signal_in(entry_signal_in), // active low
        .exit_signal_in(exit_signal_in), // active low
        .exit_slot_in(exit_slot_in),
        .SEG_SEL(SEG_SEL),
        .SEG_DATA(SEG_DATA),
        .spots(spots),
        .doorLED(doorLED),
        .fullLED(fullLED)
    );

    // Clock generation (40 MHz)
    initial begin
        clk = 0;
        forever #12.5 clk = ~clk;  // 40 MHz clock period is 25ns, half period 12.5ns
    end

    // Stimulus generation
    initial begin
        // Initialize Inputs
        reset_in = 0;
        entry_signal_in = 0;
        exit_signal_in = 0;
        exit_slot_in = 2'b00;

        // Apply reset
        #300; reset_in = 1; #200;

        // Test 1: Car entering
        entry_signal_in = 1; #200; 
        entry_signal_in = 0; #100;

        // Test 2: Car exiting
        exit_signal_in = 1; #100; 
        exit_signal_in = 0; #200;

        // Finish simulation after some time
        #1000;
        $finish;
    end

endmodule
