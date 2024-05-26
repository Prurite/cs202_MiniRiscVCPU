`timescale 1ns/1ps

module IFBuffer( //buffer between IF and ID, use to implete pipeline
  input clk, rst, stall, clear,
  input MemRead_i, MemtoReg_i, MemWrite_i, RegWrite1_i, RegWrite2_i, ecall_i,
  input [1:0] ALUSrc_i,
  input [3:0] ALUOp_i, 
  input [31:0] pc_i, inst_i,
  input [4:0] rd_i,
  input [31:0] WriteData_i,
  output reg MemRead_o, MemtoReg_o, MemWrite_o, RegWrite1_o, RegWrite2_o, ecall_o,
  output reg [1:0] ALUSrc_o,
  output reg [3:0] ALUOp_o, 
  output reg [31:0] pc_o, inst_o,
  output reg [4:0] rd_o,
  output reg [31:0] WriteData_o
);
  always @(negedge clk) begin
    WriteData_o <= rst ? WriteData_i : 32'b0;
    rd_o <= rst ? rd_i : 32'b0;
    RegWrite2_o <= rst ? RegWrite2_i : 32'b0;

    if (!rst || clear) begin
      MemRead_o <= 1'b0;
      MemtoReg_o <= 1'b0;
      MemWrite_o <= 1'b0;
      ALUSrc_o <= 2'b0;
      ALUOp_o <= 4'b0;
      RegWrite1_o <= 1'b0;
      pc_o <= 32'b0;
      inst_o <= 32'b0;
      ecall_o <= 1'b0;
    end else if (stall) begin
      MemRead_o <= MemRead_o;
      MemtoReg_o <= MemtoReg_o;
      MemWrite_o <= MemWrite_o;
      ALUSrc_o <= ALUSrc_o;
      ALUOp_o <= ALUOp_o;
      RegWrite1_o <= RegWrite1_o;
      pc_o <= pc_o;
      inst_o <= inst_o;
      ecall_o <= ecall_o;
    end else begin
      MemRead_o <= MemRead_i;
      MemtoReg_o <= MemtoReg_i;
      MemWrite_o <= MemWrite_i;
      ALUSrc_o <= ALUSrc_i;
      ALUOp_o <= ALUOp_i;
      RegWrite1_o <= RegWrite1_i;
      pc_o <= pc_i;
      inst_o <= inst_i;
      ecall_o <= ecall_i;
    end
  end
endmodule