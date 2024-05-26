`timescale 1ns/1ps

module Decoder(
    input clk, rst,
    input regWrite, EcallWrite,
    input [31:0] inst,
    input [4:0] rd_i, // Register to write in current cycle
    input [31:0] writeData, EcallResult,
    output [31:0] rs1Data, rs2Data,
    output [4:0] rd_o, // Destination register of current instruction
    output reg [31:0] imm32
);
`define op inst[6:0]
`define isEcall (`op == 7'b1110011)

    reg [31:0] r[31:0];
    wire [4:0] rs1, rs2;
    integer i;

    assign rd_o = inst[11:7];
    assign rs1 = `isEcall ? 5'd10 : inst[19:15];
    assign rs2 = `isEcall ? 5'd17 : inst[24:20];

    always @(posedge clk)
        if (!rst) begin
            for (i = 0; i < 2; i = i + 1) r[i] <= 32'b0;
            r[2] <= 32'd65536;
            for (i = 3; i < 32; i = i + 1) r[i] <= 32'b0;
        end
        else if (EcallWrite) 
            r[10] <= EcallResult;
        else 
            r[rd_i] <= regWrite && rd_i ? writeData : r[rd_i];

    assign rs1Data = r[rs1];
    assign rs2Data = r[rs2];

    always @(posedge clk)
        casez(inst[6:0])
            7'b00?0011: // I-type
                imm32 <= {{20{inst[31]}}, inst[31:20]};
            7'b1100111: // jalr
                imm32 <= {{20{inst[31]}}, inst[31:20]};
            7'b0100011: // S-type
                imm32 <= {{20{inst[31]}}, inst[31:25], inst[11:7]};
            7'b1100011: // B-type
                imm32 <= {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            7'b0?10111: // U-type
                imm32 <= {inst[31:12], 12'b0};
            7'b1101111: // J-type
                imm32 <= {{12{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            default:
                imm32 <= 32'b0;
        endcase
endmodule