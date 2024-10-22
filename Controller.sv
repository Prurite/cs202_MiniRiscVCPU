`timescale 1ns/1ps

// Supported RV32 instructions:
// beq, lw, sw, and, or, add, sub, addi, andi, ori

module Controller ( //center unit, first process the instruction
    input clk, rst,
    input [31:0] inst,
    input doBranch, EcallDone,
    output MemRead, MemtoReg, MemWrite, RegWrite, Ecall,
    output [1:0] ALUSrc,
    output reg [3:0] ALUOp
);
`define i inst[6:0]

    reg EcallWait, prevDoBranch;

    assign MemRead = (`i == 7'b0000011);
    assign MemtoReg = (`i == 7'b0000011);
    assign MemWrite = (`i == 7'b0100011);
    assign RegWrite = (`i == 7'b0000011) || (`i ==? 7'b0x10011) || (`i ==? 7'b110x111) || (`i ==? 7'b0x10111);
    assign Ecall = (`i == 7'b1110011) || EcallWait;

    always @(posedge clk) 
        prevDoBranch <= doBranch;

    always @(posedge clk) 
        if (EcallDone || !rst || doBranch || prevDoBranch) 
            // If ecall is finished,
            // or this ecall is branched off and should not be executed
            EcallWait <= 1'b0;
        else if (`i == 7'b1110011)
            EcallWait <= 1'b1;
        else
            EcallWait <= EcallWait;

    // ALUSrc[0]: 0 reg 1 pc
    assign ALUSrc[0] = (`i ==? 7'b110x111 || `i == 7'b0010111);
    // ALUSrc[1]: 0 reg 1 imm32
    assign ALUSrc[1] = (`i ==? 7'b00x0011) || (`i == 7'b0100011) || (`i ==? 7'b0x10111);

    // ALUOp: see README
    always @(*) begin
        casez(`i)
            7'b0110011: ALUOp = 4'd0;
            7'b0010011: ALUOp = 4'd1;
            7'b0?00011: ALUOp = 4'd2;
            7'b1100011: ALUOp = 4'd3;
            7'b1101111: ALUOp = 4'd4;
            7'b1100111: ALUOp = 4'd5;
            7'b0110111: ALUOp = 4'd6;
            7'b0010111: ALUOp = 4'd1;
            default: ALUOp = 4'd0;
        endcase
    end
endmodule