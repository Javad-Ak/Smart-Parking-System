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
// Tool versions:  ---
// Description:    ---
//
// Dependencies:   ---
//
// Revision: 
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

	reg  ftemp = 0;
	reg  otemp = 0;
    // State change logic
    always @(posedge clk or reset) begin
        if (~reset) begin
			  capacity = S4;
			  spots = 4'b0000;     // All spots are free (0 = free, 1 = occupied)
			  is_full = 0;
			  is_open = 0;
			  location = 2'b00;    // Default to the first slot
        end else begin
			if (is_open) begin
				if (otemp == 1'b1) begin
					is_open = 0;
					otemp = 0;
				end
				else begin
					otemp = otemp + 1;
				end
			end
			else begin
				otemp = 0;
			end
        	if (is_full) begin
				if (ftemp == 1'b1) begin
					is_full = 0;
					ftemp = 0;
				end
				else begin
					ftemp = ftemp + 1;
				end
			end
			else begin
				ftemp = 0;
			end
		  
		  // Parking management logic
		  case (capacity)
				 S3, S2, S1: begin
					  if (entry_signal) begin
							// Find the first available spot
							if (spots[0] == 1'b0) location = 2'b00;
							else if (spots[1] == 1'b0) location = 2'b01;
							else if (spots[2] == 1'b0) location = 2'b10;
							else if (spots[3] == 1'b0) location = 2'b11;

							// fill the spot
							spots[location] = 1'b1;
							is_open = 1;
					  end else if (exit_signal) begin
							// Free the selected spot
							spots[exit_slot] = 1'b0;
							is_open = 1;
					  end
				 end
				 
				S4: begin
					  if (entry_signal) begin
							// // fill the first spot
							spots[0] = 1'b1;
							is_open = 1;
					  end
				 end
				 
				S0: begin
					  if (exit_signal) begin
							// Free the selected spot
							spots[exit_slot] = 1'b0;
							is_open = 1;
					  end
				 end
			endcase
			
		  // Next state logic
        case (capacity)
				S4: begin
					 if (entry_signal) 
						  capacity = S3;
				end

				S3: begin
					 if (entry_signal)
						  capacity = S2;
					 else if (exit_signal)
						  capacity = S4;
				end

				S2: begin
					 if (entry_signal)
						  capacity = S1;
					 else if (exit_signal)
						  capacity = S3;
				end

				S1: begin
					 if (entry_signal)
						  capacity = S0;
					 else if (exit_signal)
						  capacity = S2;
				end

				S0: begin
					 is_full = 1; // Parking is full
					 if (exit_signal)
						  capacity = S1;
				end
			
        endcase
		  
        end
    end
	 
endmodule
