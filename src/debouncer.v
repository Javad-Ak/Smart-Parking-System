//This module is designed in order to stabilize the input
//if the input change for a short time the output doesn't change
//if the input doesn't change for 1_000_000 clock it appears in output

module Debouncer (
    input clk,
    input inButton,
    output reg outButton
);
    reg [19:0] counter;
    reg temp1, temp2;

    always @(posedge clk) begin
        temp1 = inButton;
        temp2 = temp1;
    end

    always @(posedge clk)begin
        if (temp2 == outButton) 
        begin
            counter = 20'd0;
        end
        else
        begin
                counter = counter + 20'd1;
            if (counter == 20'd1_000_000)
            begin
              outButton = temp2;
            end
        end
    end
endmodule