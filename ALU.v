`timescale 1ns/1ps

module ALU ( //port and relation reference from text book
    input [31:0] ReadData1, ReadData2, pc, imm32,
    input [3:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input [1:0] ALUSrc,
    output reg [31:0] ALUResult,
    output jmp, doBranch //process by harzard, doBranch play as stop, when it is active, the popeline will stop and clear error code caused by the branch
);
    wire [31:0] A, B;
    assign A = ALUSrc[0] ? pc : ReadData1;
    assign B = ALUSrc[1] ? imm32 : ReadData2;
    always @(*) begin
        casez(ALUOp)
            4'b000?: // Register and register
                case(funct3)
                    3'h0: ALUResult = ((ALUOp == 4'b0 && funct7 == 7'h20) ? A - B : A + B); // add, sub
                    3'h4: ALUResult = A ^ B; // xor
                    3'h6: ALUResult = A | B; // or
                    3'h7: ALUResult = A & B; // and
                    3'h1: ALUResult = A << B[4:0]; // sll
                    3'h5: ALUResult = ((funct7 == 7'h20) ? A >>> B[4:0] : A >> B[4:0]); //srl, sra
                    3'h2: ALUResult = $signed(A) < $signed(B) ? 1 : 0; // slt
                    3'h3: ALUResult = A < B ? 1 : 0; // sltu
                    default: ALUResult = 0;
                endcase
            4'd2: // Load and store
                ALUResult = A + B;
            4'd4:
                ALUResult = A + 4;
            4'd5:
                ALUResult = A + 4;
            4'd6:
                ALUResult = B;
            default:
                ALUResult = 32'b0;
        endcase
    end

    assign jmp = ALUOp == 4'd5;

    assign doBranch = jmp || ALUOp == 4'd4 || (ALUOp == 4'd3) && (
        (funct3 == 3'h0 && ReadData1 == ReadData2) ||  // beq
        (funct3 == 3'h1 && ReadData1 != ReadData2) ||  // bne
        (funct3 == 3'h4 && $signed(ReadData1 - ReadData2) < 0) ||  // blt
        (funct3 == 3'h5 && $signed(ReadData1 - ReadData2) >= 0) ||  // bge
        (funct3 == 3'h6 && ReadData1 < ReadData2) ||  // bltu
        (funct3 == 3'h7 && ReadData1 >= ReadData2)  // bgeu
    );
endmodule