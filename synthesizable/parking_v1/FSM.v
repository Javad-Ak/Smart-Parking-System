
module FSM(
	 input clk,
    input reset,              // Reset signal (active low)
    input entry_signal,       // Signal when a car enters
    input exit_signal,        // Signal when a exits
    input [1:0] exit_slot,    // Selects exiting spot
    output reg is_open,       // Signal to open the door
    output reg is_full,       // Signal when parking is full
    output reg [3:0] spots,   // Occupied spots
    output reg [2:0] capacity,// Current remaining capacity
    output reg [2:0] location // First available empty slot
);
    // Parameters for states based on remaining capacity
    parameter S4 = 3'b100;  // 4 slots remaining (Idle)
    parameter S3 = 3'b011;  // 3 slots remaining
    parameter S2 = 3'b010;  // 2 slots remaining
    parameter S1 = 3'b001;  // 1 slot remaining
    parameter S0 = 3'b000;  // 0 slots remaining (Full)
	
	reg [26:0]counter_f;
	reg [26:0]counter_o;

    // State change logic
    always @(negedge reset or posedge clk) begin
    if (~reset) begin
    capacity = S4;
    spots = 4'b0000;     // All spots are free (0 = free, 1 = full)
    is_full = 0;
    is_open = 0;
    location = 3'b111;    // Default to the first slot

    end else begin    
    // Door handling
	if (is_full && counter_f<40_000_000) 
		counter_f = counter_f + 1;
	else begin
		is_full = 0;
		counter_f = 0;
	end
	
	if (is_open && counter_o<40_000_000) 
		counter_o = counter_o + 1;
	else begin
		is_open = 0;
		counter_o = 0;
	end
	
    if (entry_signal) begin
        if (capacity==S0) is_full = 1;
        else is_open = 1;
    end 
    if (exit_signal && (spots[exit_slot])) is_open = 1;
     
    // Find the first available spot
    location = 3'b111;
    if (spots[0] == 1'b0) location = 3'b000;
    else if (spots[1] == 1'b0) location = 3'b001;
    else if (spots[2] == 1'b0) location = 3'b010;
    else if (spots[3] == 1'b0) location = 3'b011;

    // Parking management logic
    case (capacity)
        S3, S2, S1: begin
        if (entry_signal) begin
            // fill the spot
            spots[location] = 1'b1;
            capacity = capacity - 1;
        end
        if (exit_signal && spots[exit_slot]) begin
            // Free the selected spot
            spots[exit_slot] = 1'b0;
            capacity = capacity + 1;
        end
        end
            
        S4: begin
            if (entry_signal) begin
                // fill the first spot
                spots[0] = 1'b1;
                capacity = capacity - 1;
            end
        end
            
        S0: begin
            if (exit_signal) begin
                // Free the selected spot
                spots[exit_slot] = 1'b0;
                capacity = capacity + 1;
            end
        end
    endcase  

    end
    end
	 
endmodule
