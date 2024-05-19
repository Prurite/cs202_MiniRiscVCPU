`timescale 1ns/1ps

module Decoder(
    input clk, rst,
    input regWrite,
    input [31:0] inst,
    input [31:0] writeData,
    output [31:0] rs1Data, rs2Data,
    output reg [31:0] imm32 
);
endmodule