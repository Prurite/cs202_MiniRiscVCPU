`timescale 1ns / 1ps

module HazardDetector(
	input clk, rst,
	input [31:0] inst,
	output reg stall,
	output reg forwarding_EX_EX1,
	output reg forwarding_EX_EX2,
	output reg forwarding_MEM_EX1,
	output reg forwarding_MEM_EX2
);
    // define parameter
    localparam J     = 7'b110x111;
    localparam U     = 7'b0x10111;
    localparam LOAD  = 7'b0000011;
    localparam R     = 7'b0110011;
    localparam I     = 7'b00x0011; 
    localparam ECALL = 7'b1110011;

    reg [31:0] preInst1, preInst2;

`define op inst[6:0]
`define pre1op preInst1[6:0]
`define pre2op preInst2[6:0]
`define rs1 (`op == 7'b1110011 ? 5'd10 : inst[19:15])
`define rs2 (`op == 7'b1110011 ? 5'd17 : inst[24:20])
`define rd inst[11:7]
`define pre1rd preInst1[11:7]
`define pre2rd preInst2[11:7]

    always @(negedge clk) begin
        if (~rst) begin
            preInst1 <= 32'b0;
            preInst2 <= 32'b0;
        end else begin
            preInst1 <= stall ? 32'b0 : inst;
            preInst2 <= preInst1;
        end
    end

/*
Stall: 连续两条指令，pre1 lw 的 rd 是 cur 的 rs1 / rs2
EX-EX: 连续两条指令，pre1 不是 lw 的 rd 是 cur 的 rs1 / rs2
MEM-EX：pre2 指令的 rd 是 cur 的 rs1 / rs2
*/

	wire pre1 = `pre1op == R || `pre1op ==? I || `pre1op ==? J || `pre1op ==? U;
	wire pre2 = `pre2op == LOAD || `pre2op == R || `pre2op ==? I || `pre2op ==? J || `pre2op ==? U;

	always @(posedge clk) begin
		if (~rst) begin
			stall <= 1'b0;
			forwarding_EX_EX1 <= 1'b0;
			forwarding_MEM_EX1 <= 1'b0;
			forwarding_EX_EX2 <= 1'b0;
			forwarding_MEM_EX2 <= 1'b0;
		end else begin
			stall <= `pre1op == LOAD && (`pre1rd == `rs1 || `pre1rd == `rs2);
			forwarding_EX_EX1 <= pre1 && (`pre1rd == `rs1);
			forwarding_MEM_EX1 <= pre2 && (`pre2rd == `rs1);
			forwarding_EX_EX2 <= pre1 && (`pre1rd == `rs2);
			forwarding_MEM_EX2 <= pre2 && (`pre2rd == `rs2);
		end
	end

endmodule