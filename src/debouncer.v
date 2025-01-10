module Debouncer (
   input clk,     
   input reset, 
   input inButton,  
   output reg outButton
);
  parameter CLK_FREQUENCY = 40_000_000;
  parameter DEBOUNCE_HZ = 2;

  localparam COUNT_VALUE = CLK_FREQUENCY / DEBOUNCE_HZ;
  reg [1:0] state;
  reg [25:0] count;
  reg button_sync, button_sync_prev;

  always @(posedge clk or negedge reset) begin
    if (~reset) begin
      state <= 0;
      outButton <= 0;
      count <= 0;
      button_sync <= 0;
      button_sync_prev <= 0;
    end else begin
      button_sync <= inButton;
      button_sync_prev <= button_sync;
      outButton <= 0;

      case (state)
        0: begin
          if (button_sync && !button_sync_prev) begin // rising edge detection
            state <= 1;
            count <= 0;
          end
        end
        1: begin
          if (count < COUNT_VALUE - 1) begin
            count <= count + 1;
          end else begin
            outButton <= 1; // pulse
            state <= 0;
          end
        end
      endcase
    end
  end

endmodule
