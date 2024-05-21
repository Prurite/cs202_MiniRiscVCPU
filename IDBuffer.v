`timescale 1ns/1ps

module IDBuffer (
  input clk, rst, clear,
  input fwd_ex_1, fwd_mem_1, fwd_ex_2, fwd_mem_2,
  input [31:0] fwd_ex_data, fwd_mem_data,
  input MemRead_i, MemtoReg_i, MemWrite_i,
  input ALUSrc_i, ALUOp_i,
  input [31:0] rs1Data, rs2Data, imm32_i, instr,
  input [4:0] rd_i,
  output reg MemRead_o, MemtoReg_o, MemWrite_o,
  output reg ALUSrc_o, ALUOp_o,
  output reg [31:0] ALUdata1, ALUdata2, imm32,
  output reg [2:0] func3, reg [6:0] func7,
  output reg [4:0] rd_o
);
  wire r;
  assign neg_r = rst && !clear;

  always @(negedge clk) begin
    MemRead_o <= neg_r ? MemRead_i : 1'b0;
    MemtoReg_o <= neg_r ? MemtoReg_i : 1'b0;
    MemWrite_o <= neg_r ? MemWrite_i : 1'b0;
    ALUSrc_o <= neg_r ? ALUSrc_i : 1'b0;
    ALUOp_o <= neg_r ? ALUOp_i : 1'b0;
    imm32 <= neg_r ? imm32_i : 32'b0;
    func3 <= neg_r ? instr[14:12] : 3'b0;
    func7 <= neg_r ? instr[31:25] : 7'b0;
    rd_o <= neg_r ? rd_i : 5'b0;
  end

  always @(negedge clk) begin
    if (!neg_r)
      ALUdata1 <= 32'b0;
    else if (fwd_ex_1)
      ALUdata1 <= fwd_ex_data;
    else if (fwd_mem_1)
      ALUdata1 <= fwd_mem_data;
    else
      ALUdata1 <= rs1Data;
    if (!neg_r)
      ALUdata2 <= 32'b0;
    else if (fwd_ex_2)
      ALUdata2 <= fwd_ex_data;
    else if (fwd_mem_2)
      ALUdata2 <= fwd_mem_data;
    else
      ALUdata2 <= rs2Data;
  end
endmodule