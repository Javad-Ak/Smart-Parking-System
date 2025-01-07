`timescale 1ms / 1us

module Multiplexed_display_tb;
    // Testbench signals
    reg clk_500Hz;
    reg reset;
    reg mode;
    reg [2:0] capacity;
    reg [1:0] empty_slot;
    reg [5:0] minutes;
    reg [5:0] seconds;
    wire [6:0] seg;
    wire [3:0] anode;
    wire colon;

    // Instantiate the module
    Multiplexed_display uut (
        .clk_500Hz(clk_500Hz),
        .reset(reset),
        .mode(mode),
        .capacity(capacity),
        .empty_slot(empty_slot),
        .minutes(minutes),
        .seconds(seconds),
        .seg(seg),
        .anode(anode),
        .colon(colon)
    );

    // Generate the 500Hz clock signal
    always begin
        #1 clk_500Hz = ~clk_500Hz;
    end

    // Test stimulus
    initial begin
        // Initialize signals
        clk_500Hz = 0;
        reset = 0;  // Active low reset, so we start with reset = 0
        mode = 0;
        capacity = 3'b100;  // Initial capacity (4 free slot)
        empty_slot = 2'b00;  // First empty slot is 0
        minutes = 6'b000000;  // 0 mins
        seconds = 6'b000000;  // 0 seconds
        
        // Apply reset (reset = 0 initially, then set to 1)
        #5;
        reset = 1;  // Deassert reset (reset = 1)
        
        // Test Capacity Mode (mode = 0)
        #10;
        mode = 0;  // Capacity/Slot Mode
        capacity = 3'b010;  // 2 free slots
        empty_slot = 2'b01;  // First empty slot is 1
        #10;
        capacity = 3'b100;  // 4 free slots
        empty_slot = 2'b00;  // First empty slot is 0

        // Test Time Mode (mode = 1)
        #10;
        mode = 1;  // Time Mode
        minutes = 6'b000101;  // 15 minutes
        seconds = 6'b000011;  // 3 seconds

        #50;
        minutes = 6'b000110;  // 16 minutes
        seconds = 6'b001010;  // 30 seconds
        
        #50;
        minutes = 6'b001010;  // 20 minutes
        seconds = 6'b010100;  // 40 seconds

        #50;
        minutes = 6'b001111;  // 31 minutes
        seconds = 6'b010001;  // 33 seconds

        // End the simulation
        #100;
        $finish;
    end

    // Monitor the values
    initial begin
        $dumpfile("multest.vcd");
        $dumpvars(0, Multiplexed_display_tb);
    end

endmodule