`timescale 1ns/1ps

module Decoder(
    input clk, rst,
    input regWrite,
    input [31:0] inst,
    input [31:0] writeData,
    output [31:0] rs1Data, rs2Data,
    output reg [31:0] imm32 
);
    reg [31:0] r[31:0];
    wire [4:0] rs1, rs2, rd;
    integer i;

    assign rd = inst[11:7];
    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];

    always @(posedge clk)
        if (!rst)
            for (i = 0; i < 32; i = i + 1)
                r[i] <= 32'b0;
        else
            r[rd] <= regWrite && rd ? writeData : r[rd];

    assign rs1Data = r[rs1];
    assign rs2Data = r[rs2];

    always @*
        casex(inst[6:0])
            7'b00x0011: // I-type
                imm32 <= {{20{inst[31]}}, inst[31:20]};
            7'b0100011: // S-type
                imm32 <= {{20{inst[31]}}, inst[31:25], inst[11:7]};
            7'b1100011: // SB-type
                imm32 <= {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            7'b0x10111: // U-type
                imm32 <= {inst[31:12], 12'b0};
            7'b1101111: // UJ-type
                imm32 <= {{12{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            default:
                imm32 <= 32'b0;
        endcase
endmodule