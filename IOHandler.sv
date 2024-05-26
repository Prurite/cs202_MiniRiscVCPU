`timescale 1ns/1ps

module IOHandler ( //process input from terminal and output to display module
	input clk, rst, Ecall,
	input [7:0] switches,
	input button,
	input [31:0] a0, a7,
	output reg EcallDone, EcallWrite, EcallWait, needWrite,
	output reg [31:0] EcallResult,
	output reg [31:0] SegData
);
	reg slowPrevButton, fastPrevButton;
	wire clk_slow;

	ClkDiv uClkDiv(.clk(clk), .rst(rst), .clk_o(clk_slow));

	always @(posedge clk_slow) //use slow clock to debounce button
		slowPrevButton <= button;

	always @(posedge clk) //detect the change of button
		fastPrevButton <= slowPrevButton;

	always @(posedge clk) begin //ecalldone, ecallwrite, ecallwait, denote the state of system call
		if (!rst) begin
			{ EcallWait, EcallDone, EcallWrite, needWrite } <= 4'b0;
			SegData <= 32'b0;
		end
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
		end else begin
			EcallWait <= EcallWait;
			EcallDone <= EcallDone;
			EcallWrite <= EcallWrite;
			needWrite <= needWrite;
			SegData <= SegData;
		end
	end
endmodule