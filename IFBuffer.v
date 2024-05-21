`timescale 1ns/1ps

module IFBuffer(
  input clk, rst, stall, clear,
  input MemRead_i, MemtoReg_i, MemWrite_i, ALUSrc_i, RegWrite_i,
  input [1:0] ALUOp_i, 
  input [31:0] inst_i,
  input [4:0] rd_i,
  input [31:0] WriteData_i,
  output reg MemRead_o, MemtoReg_o, MemWrite_o, ALUSrc_o, RegWrite_o,
  output reg [1:0] ALUOp_o, 
  output reg [31:0] inst_o,
  output reg [4:0] rd_o,
  output reg [31:0] WriteData_o
);
  always @(negedge clk) begin
    if (!rst || clear) begin
      MemRead_o <= 1'b0;
      MemtoReg_o <= 1'b0;
      MemWrite_o <= 1'b0;
      ALUSrc_o <= 1'b0;
      ALUOp_o <= 2'b0;
      RegWrite_o <= 1'b0;
      inst_o <= 32'b0;
      rd_o <= 5'b0;
      WriteData_o <= 32'b0;
    end else if (stall) begin
      MemRead_o <= MemRead_o;
      MemtoReg_o <= MemtoReg_o;
      MemWrite_o <= MemWrite_o;
      ALUSrc_o <= ALUSrc_o;
      ALUOp_o <= ALUOp_o;
      RegWrite_o <= RegWrite_o;
      inst_o <= inst_o;
      rd_o <= rd_o;
      WriteData_o <= WriteData_o;
    end else begin
      MemRead_o <= MemRead_i;
      MemtoReg_o <= MemtoReg_i;
      MemWrite_o <= MemWrite_i;
      ALUSrc_o <= ALUSrc_i;
      ALUOp_o <= ALUOp_i;
      RegWrite_o <= RegWrite_i;
      inst_o <= inst_i;
      rd_o <= rd_i;
      WriteData_o <= WriteData_i;
    end
  end
endmodule