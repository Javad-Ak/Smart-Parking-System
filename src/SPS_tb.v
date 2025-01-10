`timescale 1ns / 1ps

module SPS_tb;

    // Inputs
    reg clk;
    reg reset_in;
    reg entry_signal_in;
    reg exit_signal_in;
    reg [1:0] exit_slot_in;

    // Outputs
    wire [3:0] anode;
    wire [6:0] segments;
    wire colon;
    wire [3:0] spots;
    wire doorLED;
    wire fullLED;

    // Instantiate the Unit Under Test (UUT)
    SPS uut (
        .clk(clk),
        .reset_in(reset_in),
        .entry_signal_in(entry_signal_in),
        .exit_signal_in(exit_signal_in),
        .exit_slot_in(exit_slot_in),
        .anode(anode),
        .segments(segments),
        .colon(colon),
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
        #25 reset_in = 1;  // Reset for 5ns

        // Test 1: Car entering the parking
        entry_signal_in = 1;  // Car enters
        #25 entry_signal_in = 0;  // Car entry signal goes low

        // Test 2: Car exiting the parking
        exit_signal_in = 1;  // Car exits
        #25 exit_signal_in = 0;  // Car exit signal goes low

        // Finish simulation after some time
        #100;
        $finish;
    end

endmodule
