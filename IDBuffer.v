`timescale 1ns/1ps

module IDBuffer ( //buffer between ID and EX, use to implete pipeline
  input clk, rst, clear,
  input fwd_ex_1, fwd_mem_1, fwd_ex_2, fwd_mem_2,
  input [31:0] fwd_ex_data, fwd_mem_data,
  input MemRead_i, MemtoReg_i, MemWrite_i, RegWrite_i, ecall_i,
  input [1:0] ALUSrc_i,
  input [3:0] ALUOp_i,
  input [31:0] rs1Data_i, rs2Data_i, imm32_i, pc_i, inst,
  input [4:0] rd_i,
  output reg MemRead_o, MemtoReg_o, MemWrite_o, RegWrite_o, ecall_o,
  output reg [1:0] ALUSrc_o,
  output reg [3:0] ALUOp_o,
  output reg [31:0] rs1Data_o, rs2Data_o, imm32_o, pc_o,
  output reg [2:0] func3,
  output reg [6:0] func7,
  output reg [4:0] rd_o
);
  assign neg_r = rst && !clear;

  always @(negedge clk) begin 
    MemRead_o <= neg_r ? MemRead_i : 1'b0;
    MemtoReg_o <= neg_r ? MemtoReg_i : 1'b0;
    MemWrite_o <= neg_r ? MemWrite_i : 1'b0;
    RegWrite_o <= neg_r ? RegWrite_i : 1'b0;
    ALUSrc_o <= neg_r ? ALUSrc_i : 2'b0;
    ALUOp_o <= neg_r ? ALUOp_i : 4'b0;
    imm32_o <= neg_r ? imm32_i : 32'b0;
    pc_o <= neg_r ? pc_i : 32'b0;
    func3 <= neg_r ? inst[14:12] : 3'b0;
    func7 <= neg_r ? inst[31:25] : 7'b0;
    rd_o <= neg_r ? rd_i : 5'b0;
    ecall_o <= neg_r ? ecall_i : 1'b0;
  end

  always @(negedge clk) begin 
    if (!neg_r)
      rs1Data_o <= 32'b0;
    else if (fwd_ex_1)
      rs1Data_o <= fwd_ex_data;
    else if (fwd_mem_1)
      rs1Data_o <= fwd_mem_data;
    else
      rs1Data_o <= rs1Data_i;
    if (!neg_r)
      rs2Data_o <= 32'b0;
    else if (fwd_ex_2)
      rs2Data_o <= fwd_ex_data;
    else if (fwd_mem_2)
      rs2Data_o <= fwd_mem_data;
    else
      rs2Data_o <= rs2Data_i;
  end
endmodule