`timescale 1ps/1ps

module BCDTest;
    reg [2:0] binary;
    wire [6:0] seg;


    BCD7seg uut (.binary(binary), .seg(seg));


    initial begin
        $dumpfile("BCDtest.vcd");
        $dumpvars(0, BCDTest);
        binary = 3'b000;
        #20 binary = 3'b001;
        #20 binary = 3'b110; //invalid input
        #20 binary = 3'b010;
        #20 binary = 3'b011;
        #20 binary = 3'b100;
        #20;
        $finish;
    end

endmodule