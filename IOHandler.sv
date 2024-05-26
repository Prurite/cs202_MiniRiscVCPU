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
	reg slowPrevButton, fastPrevButton;
	reg EcallWait;
	wire clk_slow;
	reg needWrite;

	// Instantiate the 7-segment display module
	// TODO

	ClkDiv uClkDiv( .clk(clk), .rst(rst), .clk_o(clk_slow));

	always @(posedge clk_slow)
		slowPrevButton <= button;

	always @(posedge clk)
		fastPrevButton <= slowPrevButton;

	always @(posedge clk) begin
		if (!rst)
			{ EcallWait, EcallDone, EcallWrite, needWrite } <= 4'b0;
		else if (EcallDone)
			{ EcallWrite, EcallDone } <= 1'b0;
		else if (Ecall && !EcallWait) begin
			EcallWait <= 1'b1;
			SegData <= a7 == 32'd1 ? a0 : 32'd0; // output
			needWrite <= a7 == 32'd5;
		end else if (EcallWait && !fastPrevButton && slowPrevButton) begin
			EcallWait <= 1'b0;
			EcallDone <= 1'b1;
			EcallWrite <= needWrite;
			EcallResult <= needWrite ? {24'b0, switches} : 32'd0; // input
		end
	end
endmodule