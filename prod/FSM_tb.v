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

    // Instantiate the FSM module
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

    // Test sequence variables
    reg [3:0] test_data [0:19]; // Array to store the test inputs
    integer i;
    integer outfile; // File handle for output

    // Read inputs and output results
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        #10;
        reset = 1; // Release reset after some time

        // Open output file
        outfile = $fopen("../doc/out.txt", "w");

        // Read test data from input file
        $readmemb("../doc/in.txt", test_data);

        // Apply each test vector
        for (i = 0; i < 20; i = i + 1) begin
            {entry_signal, exit_signal, exit_slot} = test_data[i];
            #10; // Wait for a clock cycle to apply changes

            // Write results to output file
            $fdisplay(outfile, "%b %d %d %b %b", spots, capacity, location, is_full, is_open);
        end

        $fclose(outfile); // Close the output file
        $finish; // End simulation
    end

endmodule
