`timescale 1ns/1ps

module IOHandler (
	input clk, rst, Ecall,
	input [7:0] switches,
	input button,
	input [31:0] a0, a7,
	output reg EcallDone, EcallWrite,
	output reg [31:0] EcallResult,
	output [7:0] seg [1:0],
	output [3:0] seg_sel [1:0]
);
	reg [31:0] SegData;
	reg prevButton;
	reg EcallWait;
	wire clk_slow;

	// Instantiate the 7-segment display module
	// TODO

	ClkDiv uClkDiv( .clk(clk), .rst(rst), .clk_o(clk_slow));

	always @(posedge clk_slow)
		prevButton <= button;

	always @(posedge clk) begin
		if (!rst)
			{ EcallWait, EcallDone, EcallWrite } <= 3'b0;
		else if (Ecall && !EcallWait) begin
			EcallWait <= 1'b1;
			SegData <= a7 == 32'd1 ? a0 : 32'd0; // output
		end else if (EcallWait && !prevButton && button) begin
			EcallWait <= 1'b0;
			EcallDone <= 1'b1;
			EcallWrite <= a7 == 32'd5;
			EcallResult <= a7 == 32'd5 ? {24'b0, switches} : 32'd0; // input
		end else if (EcallDone)
			EcallDone <= 1'b0;
	end
endmodule