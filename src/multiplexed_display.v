module multiplexed_display (
    input clk_500Hz,    
    input reset,                
    input mode,         
    input [2:0] capacity,     
    input [1:0] empty_slot,   
    input [5:0] minutes,      
    input [5:0] seconds,      
    output reg [6:0] seg,          
    output reg [3:0] anode,
    output reg colon         
);

    reg [3:0] digit;             // Current digit to display
    reg [1:0] digit_select;      // Digit selector (0-3)

    // 7-segment decoder
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b0000001; // 0
            4'd1: seg = 7'b1001111; // 1
            4'd2: seg = 7'b0010010; // 2
            4'd3: seg = 7'b0000110; // 3
            4'd4: seg = 7'b1001100; // 4
            4'd5: seg = 7'b0100100; // 5
            4'd6: seg = 7'b0100000; // 6
            4'd7: seg = 7'b0001111; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0000100; // 9
            default: seg = 7'b1111111; // Blank (all segments off)
        endcase
    end

    // Multiplexing logic
    always @(posedge clk_500Hz or reset) begin
        if (~reset) begin
            digit_select = 0;
            anode = 4'b1111;  // Turn off all digits
        end else begin
            // Cycle through the four digits
            digit_select = digit_select + 1;
            anode = 4'b1111; // Turn off all digits
            case (digit_select)
                2'd0: anode = 4'b1110; // Activate first digit
                2'd1: anode = 4'b1101; // Activate second digit
                2'd2: anode = 4'b1011; // Activate third digit
                2'd3: anode = 4'b0111; // Activate fourth digit
            endcase
        end
    end

    // Determine which value to display
    always @(*) begin
        colon = (mode == 0) ? 1 : 0;
        case (digit_select)
            2'd0: digit = (mode == 0) ? capacity : (minutes / 10);    // capacity or tens of minutes
            2'd1: digit = (mode == 0) ? 4'd15 : (minutes % 10); // Blank or units of minutes
            2'd2: digit = (mode == 0) ? empty_slot : (seconds / 10);      // slots or tens of seconds
            2'd3: digit = (mode == 0) ? 4'd15 : (seconds % 10);      // Blank (4'd15) or units of seconds
        endcase
    end

endmodule