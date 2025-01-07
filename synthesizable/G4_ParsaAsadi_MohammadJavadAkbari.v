`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AUT
// Engineers: Mohammad Javad Akbari, Parsa Asadi
// 
// Create Date:    13:32:48 12/08/2024 
// Design Name: 	 FSM
// Module Name:    FSM 
// Project Name:   PMS
// Target Devices: Spartan 3
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module FSM(
    input clk,                // Clock signal
    input reset,              // Reset signal (active low)
    input entry_signal,       // Signal when a car enters
    input exit_signal,        // Signal when a exits
    input [1:0] exit_slot,    // Selects exiting spot
    output reg is_open,       // Signal to open the door
    output reg is_full,       // Signal when parking is full
    output reg [3:0] spots,   // Occupied spots
    output reg [2:0] capacity,// Current remaining capacity
    output reg [1:0] location // First available empty slot
);
    // Parameters for states based on remaining capacity
    parameter S4 = 3'b100;  // 4 slots remaining (Idle)
    parameter S3 = 3'b011;  // 3 slots remaining
    parameter S2 = 3'b010;  // 2 slots remaining
    parameter S1 = 3'b001;  // 1 slot remaining
    parameter S0 = 3'b000;  // 0 slots remaining (Full)

    // State change logic
    always @(posedge clk or reset) begin
    if (~reset) begin
    capacity = S4;
    spots = 4'b0000;     // All spots are free (0 = free, 1 = full)
    is_full = 0;
    is_open = 0;
    location = 2'b00;    // Default to the first slot

    end else begin    
    // Door handling
    is_full = 0;
    is_open = 0;
    if (entry_signal) begin
        if (capacity==S0) is_full = 1;
        else is_open = 1;
    end 
    if (exit_signal && (spots[exit_slot])) is_open = 1;

    // Parking management logic
    case (capacity)
        S3, S2, S1: begin
        if (entry_signal) begin
            // fill the spot
            spots[location] = 1'b1;
            capacity--;
        end
        if (exit_signal && spots[exit_slot]) begin
            // Free the selected spot
            spots[exit_slot] = 1'b0;
            capacity++;
        end
        end
            
        S4: begin
            if (entry_signal) begin
                // fill the first spot
                spots[0] = 1'b1;
                capacity--;
            end
        end
            
        S0: begin
            if (exit_signal) begin
                // Free the selected spot
                spots[exit_slot] = 1'b0;
                capacity++;
            end
        end
    endcase  
 
    // Find the first available spot
    location = 2'bzz;
    if (spots[0] == 1'b0) location = 2'b00;
    else if (spots[1] == 1'b0) location = 2'b01;
    else if (spots[2] == 1'b0) location = 2'b10;
    else if (spots[3] == 1'b0) location = 2'b11;

    end
    end
	 
endmodule
