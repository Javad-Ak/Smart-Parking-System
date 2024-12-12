module BCD7seg(input [2:0] binary,
               output reg [6:0] seg); //seg[0]:top seg[1]:right top seg[2]:right down seg[3]:down
               //seg[4]:left down seg[5]:left top seg[6]:middle
    always @ (*) begin
        case (binary)
            3'b000: seg = 7'b0111111;
            3'b001: seg = 7'b0000110;
            3'b010: seg = 7'b1011011;
            3'b011: seg = 7'b1001111;
            3'b100: seg = 7'b1100110;
            default: seg = 7'b0000000; //invalid input
        endcase
    end
endmodule