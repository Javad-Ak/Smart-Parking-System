
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: AUT
// Engineers: Mohammad Javad Akbari, Parsa Asadi
//
// Create Date:   14:03:35 12/08/2024
// Design Name:   FSM
// Module Name:   /home/javad/ISE/Project/FSM_TB.v
// Project Name:  Project
// Target Device: ---
// Tool versions: ---
// Description:   ---
//
// Verilog Test Fixture created by ISE for module: FSM
//
// Dependencies:  ---
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: ---
// 
////////////////////////////////////////////////////////////////////////////////

module FSM_TB;

    // Inputs
    reg clk;
    reg reset;
    reg entry_signal;
    reg exit_signal;
    reg [1:0] exit_slot;

    // Outputs
    wire is_open;
    wire is_full;
    wire [3:0] spots;
    wire [2:0] capacity;
    wire [1:0] location;

    // Instantiate the ParkingSystem module
    FSM uut (
        .clk(clk),
        .reset(reset),
        .entry_signal(entry_signal),
        .exit_signal(exit_signal),
        .exit_slot(exit_slot),
        .is_open(is_open),
        .is_full(is_full),
        .spots(spots),
        .capacity(capacity),
        .location(location)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        entry_signal = 0;
        exit_signal = 0;
        exit_slot = 2'b00;

        // Enable machine
        #10 reset = 1; 

        // Test case 1: First car enters
        #10 entry_signal = 1;
        #10 entry_signal = 0; // Simulate a short entry pulse

        // Test case 2: Second car enters
        #10 entry_signal = 1;
        #10 entry_signal = 0;

        // Test case 3: Third car enters
        #10 entry_signal = 1;
        #10 entry_signal = 0;

        // Test case 4: Fourth car enters (parking is full)
        #10 entry_signal = 1;
        #10 entry_signal = 0;

        // Check is_full signal
        #10;

        // Test case 5: A car exits from slot 2
        #10 exit_signal = 1;
        exit_slot = 2'b10; // Specify the slot
        #10 exit_signal = 0;

        // Test case 6: Another car enters
        #10 entry_signal = 1;
        #10 entry_signal = 0;

        #50;
		  $finish;
    end

endmodule
