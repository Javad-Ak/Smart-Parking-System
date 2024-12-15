module FSM_TB;

    // Inputs
    reg clk;
    reg reset; // Active-low reset
    reg entry_signal;
    reg exit_signal;
    reg [1:0] exit_slot;

    // Outputs
    wire is_open;
    wire is_full;
    wire [3:0] spots;
    wire [2:0] capacity;
    wire [1:0] location;

    // Instantiate the FSM module
    FSM uut (
        .clk(clk),
        .reset(reset), // Active-low reset
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

    // Test sequence variables
    reg [3:0] test_data [0:19]; // Memory array to store input data
    integer i;
    integer outfile; // File handle for output

    // Main test process
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0; // Assert reset (active-low) initially
        entry_signal = 0;
        exit_signal = 0;
        exit_slot = 0;

        // Hold reset for some time and release
        #10 reset = 1;

        // Open input and output files
        $readmemb("../doc/in.txt", test_data); // Read inputs into test_data array
        outfile = $fopen("../doc/out.txt", "w");
        if (outfile == 0) begin
            $display("Error: Could not open out.txt for writing.");
            $finish;
        end

        // Apply each test vector
        for (i = 0; i < 20; i = i + 1) begin
            // Apply test inputs
            {entry_signal, exit_signal, exit_slot} = test_data[i];
            #10; // Wait for a clock cycle to stabilize signals

            // Write outputs to file
            $fwrite(outfile, "%b %d %d", spots, capacity, location);
            if (is_open)
                $fwrite(outfile, " door");
            if (is_full)
                $fwrite(outfile, " full");
            $fwrite(outfile, "\n");
        end

        // Close output file and finish
        $fclose(outfile);
        $display("Simulation complete. Results written to out.txt.");
        $finish;
    end

endmodule
