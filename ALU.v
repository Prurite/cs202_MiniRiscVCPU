`timescale 1ns/1ps

module ALU (
    input clk, rst,
    input [31:0] ReadData1, ReadData2, imm32,
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input ALUSrc,
    output reg [31:0] ALUResult,
    output doBranch
);
    wire [31:0] A, B;
    assign A = ReadData1;
    assign B = ALUSrc ? imm32 : ReadData2;
    always @(posedge clk) begin
        if (~rst) ALUResult <= 32'b0;
        else begin
            case(ALUOp)
                2'b00: // load/store
                    ALUResult <= A + B;
                2'b01: // branch
                    ALUResult <= A - B;
                2'b10: // register arithmatic: add, sub, and, or
                    case(funct3)
                        3'h0: ALUResult <= ((funct7 == 7'h00) ? A + B : A - B); // add, sub
                        3'h4: ALUResult <= A ^ B; //xor
                        3'h6: ALUResult <= A | B; // or
                        3'h7: ALUResult <= A & B; // and
                        3'h1: ALUResult <= A << B[4:0]; // sll
                        3'h5: ALUResult <= ((funct7 == 7'h20) ? A >>> B[4:0] : A >> B[4:0]); //srl, sra
                        default: ALUResult <= 0;
                    endcase
                2'b11: // register with immediate: addi, ori, andi
                    case(funct3)
                        3'h0: ALUResult <= A + imm32; // addi
                        3'h4: ALUResult <= A ^ imm32; // xori
                        3'h6: ALUResult <= A | imm32; // ori
                        3'h7: ALUResult <= A & imm32; // andi
                        3'h1: ALUResult <= A << imm32[4:0]; // sll
                        3'h5: ALUResult <= ((imm32[11:5] == 7'h20) ? A >>> imm32[4:0] : A >> imm32[4:0]); //srli, srai
                        default: ALUResult <= 0;
                    endcase
            endcase
        end
    end



    assign doBranch = (ALUOp == 2'b01) && (
        (funct3 == 3'h0 && ReadData1 == ReadData2) ||  // beq
        (funct3 == 3'h1 && ReadData1 != ReadData2) ||  // bne
        (funct3 == 3'h4 && $signed(ReadData1 - ReadData2) < 0) ||  // blt
        (funct3 == 3'h5 && $signed(ReadData1 - ReadData2) >= 0) ||  // bge
        (funct3 == 3'h6 && ReadData1 < ReadData2) ||  // bltu
        (funct3 == 3'h7 && ReadData1 >= ReadData2)  // bgeu
    );
endmodule