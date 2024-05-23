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
    localparam JAL   = 7'b1101111;
    localparam JALR  = 7'b1100111;
    localparam LUI   = 7'b0110111;
    localparam AUIPC = 7'b0010111;
    localparam ECALL = 7'b1110011;
    localparam LOAD  = 7'b0000011;
    localparam RTYPE = 7'b0110011;
    localparam ILOAD = 7'b0010011; // Immediate with reg
    localparam ITYPE = 7'b00x0011; 

    reg [31:0] preInst1, preInst2;

`define opcode inst[6:0]
`define pre1op preInst1[6:0]
`define pre2op preInst2[6:0]
`define rs1 inst[19:15]
`define rs2 inst[24:20]
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

	always @(posedge clk) begin
		if (~rst) begin
			stall <= 1'b0;
			forwarding_EX_EX1 <= 1'b0;
			forwarding_MEM_EX1 <= 1'b0;
			forwarding_EX_EX2 <= 1'b0;
			forwarding_MEM_EX2 <= 1'b0;
		end else begin
			stall <= `pre1op == LOAD && (`pre1rd == `rs1 || `pre1rd == `rs2);
			forwarding_EX_EX1 <= (`pre1op == RTYPE || `pre1op == ILOAD) && (`pre1rd == `rs1);
			forwarding_MEM_EX1 <= (`pre2op == LOAD) && (`pre2rd == `rs1);
			forwarding_EX_EX2 <= (`pre1op == RTYPE || `pre1op == ILOAD) && (`pre1rd == `rs2);
			forwarding_MEM_EX2 <= (`pre2op == LOAD) && (`pre2rd == `rs2);
		end
	end

endmodule