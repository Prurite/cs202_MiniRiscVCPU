`timescale 1ns/1ps

// Supported RV32 instructions:
// beq, lw, sw, and, or, add, sub, addi, andi, ori

module Controller (
    input [31:0] inst,
    output MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp
);
    wire [6:0] i;
    assign i = inst[6:0];
    assign MemRead = (i == 7'b0000011);
    assign MemtoReg = (i == 7'b0000011);
    assign MemWrite = (i == 7'b0100011);
    assign ALUSrc = (i == 7'b0000011) || (i == 7'b0100011) ||| (i == 7'b0010011);
    assign RegWrite = (i == 7'b0000011) || (i == 7'b0110011) || (i == 7'b0010011);
    // ALUOp: 00 load/store, 01 branch, 10 R-type, 11 others
    always @(*) begin
        case(i)
            7'b0000011: ALUOp = 2'b00; // load
            7'b0100011: ALUOp = 2'b00; // store
            7'b1100011: ALUOp = 2'b01; // branch
            7'b0110011: ALUOp = 2'b10; // R-type
            7'b0010011: ALUOp = 2'b11; // I-type (with reg)
            default: ALUOp = 2'b00;
        endcase
    end
endmodule