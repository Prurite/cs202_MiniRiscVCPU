`timescale 1ns/1ps

module ClkDiv( //clk divider, 100MHz -> 13.33MHz
	input clk, rst,
	output reg clk_o
);
	integer cnt = 0;
	always @(posedge clk)
		if (!rst) begin
			clk_o <= 1'b0;
			cnt <= 0;
		end else if (cnt == 15000) begin
		// end else if (cnt == 1) begin
			clk_o <= ~clk_o;
			cnt <= 0;
		end else
			cnt <= cnt + 1;
endmodule
