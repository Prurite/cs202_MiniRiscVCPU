`timescale 1ns/1ps

module EXBuffer(
  input clk, rst,
  input MemRead_i, MemtoReg_i, MemWrite_i,
  input [31:0] ALUResult_i, MemData_i,
  input [4:0] rd_i,
  output reg MemRead_o, MemtoReg_o, MemWrite_o,
  output reg [31:0] ALUResult_o, MemData_o,
  output reg [4:0] rd_o
);
  always @(negedge clk) begin
    MemRead_o <= rst ? MemRead_i : 1'b0;
    MemtoReg_o <= rst ? MemtoReg_i : 1'b0;
    MemWrite_o <= rst ? MemWrite_i : 1'b0;
    ALUResult_o <= rst ? 32'b0 : ALUResult_i;
    MemData_o <= rst ? 32'b0 : MemData_i;
    rd_o <= rst ? rd_i : 5'b0;
  end
endmodule 

