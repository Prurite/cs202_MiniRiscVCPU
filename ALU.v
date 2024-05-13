`timescale 1ns/1ps

module ALU (
    input [31:0] ReadData1, ReadData2, imm32,
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input ALUSrc,
    output reg [31:0] ALUResult,
    output zero
);
    wire [31:0] A, B;
    assign A = ReadData1;
    assign B = ALUSrc ? imm32 : ReadData2;
    always @(*) begin
        case(ALUOp)
            2'b00: // load/store
                ALUResult = A + B;
            2'b01: // branch
                ALUResult = A - B;
            2'b10: // register arithmatic: add, sub, and, or, addi, andi, ori
                case(funct3)
                    3'h0: ALUResult = (funct7 == 7'h00 ? A + B : A - B); // add, sub
                    3'h7: ALUResult = A & B; // and
                    3'h6: ALUResult = A | B; // or
                    default: ALUResult = 0;
                endcase
        endcase
    end
    assign zero = (ALUResult == 0);
endmodule