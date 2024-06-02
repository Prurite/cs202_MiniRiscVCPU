`timescale 1ns/1ps

module IOHandler (
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

	always @(posedge clk_slow) // Use slow clock to debounce button
		slowPrevButton <= button;

	always @(posedge clk) // Detect the change of button
		fastPrevButton <= slowPrevButton;

    always @(posedge clk) begin // State machine
        if (!rst) begin // Reset
			{ EcallWait, EcallDone, EcallWrite, needWrite } <= 4'b0;
			SegData <= 32'b0;
        end else if (EcallDone) // Current ecall finished; to idle
			{ EcallWrite, EcallDone } <= 1'b0;
        else if (Ecall && !EcallWait) begin // A new ecall coming in; to wait
			EcallWait <= 1'b1;
            SegData <= a7 == 32'd1 ? a0 : 32'd0; // Send data to output
			needWrite <= a7 == 32'd5; // Remember if it's a read and needs to write reg
        end else if (EcallWait && !fastPrevButton && slowPrevButton) begin
            // Button pressed; to done
			EcallWait <= 1'b0;
			EcallDone <= 1'b1;
			EcallWrite <= needWrite;
			EcallResult <= needWrite ? {24'b0, switches} : 32'd0; // input
		end else begin // Stay current state
			EcallWait <= EcallWait;
			EcallDone <= EcallDone;
			EcallWrite <= EcallWrite;
			needWrite <= needWrite;
			SegData <= SegData;
		end
	end
endmodule