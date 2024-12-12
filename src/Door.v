module Door (
    input clk_2Hz,          // 2Hz clock input
    input reset,            // Reset signal
    input open_signal,      // Signal to start LED blinking
    output reg DoorLED          // LED output
);

    reg [4:0] counter = 5'd0;  // 5-bit counter for 20 cycles (10 seconds)
    reg latch = 1'b0;          // Latch to retain open_signal

    always @(posedge clk_2Hz or reset) begin
        if (~reset) begin
            counter = 5'd0;   // Reset counter to 0
            latch = 1'b0;     // Clear the latch
            DoorLED = 1'b0;       // Turn off LED
        end
        else begin
            // Latch the open_signal when it goes high
            if (open_signal && !latch) begin
                latch = 1'b1; // Set latch
                counter = 5'd0; // Start counting from 0
            end

            // If latched, toggle LED and count
            if (latch) begin
                if (counter < 5'd20) begin
                    counter = counter + 1; // Increment counter
                    DoorLED = ~DoorLED;            // Toggle LED
                end
                else begin
                    latch = 1'b0;          // Release latch after 10 seconds
                    DoorLED = 1'b0;            // Turn off LED
                end
            end
        end
    end

endmodule