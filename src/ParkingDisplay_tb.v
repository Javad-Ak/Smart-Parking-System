`timescale 1ms/1ns // Use milliseconds for time units, nanoseconds for precision

module ParkingDisplay_tb;

    // Testbench signals
    reg clk_500Hz;
    reg reset;
    reg [2:0] capacity;
    reg [1:0] first_empty;
    wire [1:0] anodes;
    wire [6:0] segments;

    // Instantiate the ParkingDisplay module
    ParkingDisplay uut (
        .clk_500Hz(clk_500Hz),
        .reset(reset),
        .capacity(capacity),
        .first_empty(first_empty),
        .anodes(anodes),
        .segments(segments)
    );

    // Generate a 500 Hz clock (1 ms period)
    always begin
        #0.5 clk_500Hz = ~clk_500Hz;
    end

    // Testbench procedure
    initial begin
        // Initialize inputs
        clk_500Hz = 0;
        reset = 0;
        capacity = 3'd0;    // Start with 0 free slots
        first_empty = 2'd0; // Start with slot 0

        // Release reset after 2 ms
        #2 reset = 1;

        // Test case 1: Capacity = 4, First Empty Slot = 0
        #5 capacity = 3'd4;
           first_empty = 2'd0;

        // Test case 2: Capacity = 3, First Empty Slot = 1
        #10 capacity = 3'd3;
            first_empty = 2'd1;

        // Test case 3: Capacity = 2, First Empty Slot = 2
        #10 capacity = 3'd2;
            first_empty = 2'd2;

        // Test case 4: Capacity = 1, First Empty Slot = 3
        #10 capacity = 3'd1;
            first_empty = 2'd3;

        // Test case 5: Capacity = 0, No Empty Slots
        #10 capacity = 3'd0;
            first_empty = 2'd0;

        // End simulation
        #20 $finish;
    end

    // Dump waveform data for GTKWave
    initial begin
        $dumpfile("ParkingDisplay_tb.vcd");
        $dumpvars(0, ParkingDisplay_tb);
    end

endmodule