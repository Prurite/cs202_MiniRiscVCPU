`timescale 1ns/1ps

module main (
    input clk, rst
);
    wire [31:0] inst_if_o, pc_if_o;

    wire MemRead_if_o, MemtoReg_if_o, MemWrite_if_o, RegWrite_if_o;
    wire [1:0] ALUSrc_if_o;
    wire [3:0] ALUOp_if_o;

    wire Memread_id_i, MemtoReg_id_i, MemWrite_id_i, RegWrite1_id_i, RegWrite2_id_i;
    wire [1:0] ALUSrc_id_i;
    wire [3:0] ALUOp_id_i;
    wire [4:0] rd_id_i;
    wire [31:0] inst_id_i, pc_id_i, WriteData_id_i;

    wire [31:0] rs1Data_id_o, rs2Data_id_o, imm32_id_o;
    wire [4:0] rd_id_o;
    wire fwd_ex_1_id_o, fwd_ex_2_id_o, fwd_mem_1_id_o, fwd_mem_2_id_o;

    wire MemRead_ex_i, MemtoReg_ex_i, MemWrite_ex_i, RegWrite_ex_i;
    wire [1:0] ALUSrc_ex_i;
    wire [3:0] ALUOp_ex_i;
    wire [31:0] rs1Data_ex_i, rs2Data_ex_i, imm32_ex_i, pc_ex_i;
    wire [2:0] func3_ex_i;
    wire [6:0] func7_ex_i;
    wire [4:0] rd_ex_i;

    wire [31:0] ALUResult_ex_o;
    wire jmp_ex_o, doBranch_ex_o;

    wire MemRead_mem_i, MemtoReg_mem_i, MemWrite_mem_i, RegWrite_mem_i;
    wire [31:0] ALUResult_mem_i, MemData_mem_i;
    wire [4:0] rd_mem_i;

    wire [31:0] MemData_mem_o;

    wire stall;

    IFetch uIFetch(
        .clk(clk), .rst(rst), .stall(stall),
        .jmp(jmp_ex_o), .doBranch(doBranch_ex_o), // may have mistake when the clock is too fast
        .imm32(imm32_ex_i), .rs1(rs1Data_ex_i), //db and imm are prepared at pos and used at neg
        .pc(pc_if_o),
        .inst(inst_if_o)
    );

    Controller uController(
        .inst(inst_if_o),
        .MemRead(MemRead_if_o),
        .MemtoReg(MemtoReg_if_o),
        .MemWrite(MemWrite_if_o),
        .ALUSrc(ALUSrc_if_o),
        .RegWrite(RegWrite_if_o),
        .ALUOp(ALUOp_if_o)
    );

    IFBuffer uIFBuffer(
        .clk(clk), .rst(rst), .stall(stall), .clear(doBranch_ex_o),
        .MemRead_i(MemRead_if_o), .MemtoReg_i(MemtoReg_if_o), .MemWrite_i(MemWrite_if_o),
        .ALUSrc_i(ALUSrc_if_o), .RegWrite1_i(RegWrite_if_o), .RegWrite2_i(RegWrite_mem_i), .ALUOp_i(ALUOp_if_o),
        .pc_i(pc_if_o), .inst_i(inst_if_o), .rd_i(rd_mem_i), .WriteData_i(MemData_mem_o),
        .MemRead_o(Memread_id_i), .MemtoReg_o(MemtoReg_id_i), .MemWrite_o(MemWrite_id_i),
        .ALUSrc_o(ALUSrc_id_i), .RegWrite1_o(RegWrite1_id_i), .RegWrite2_o(RegWrite2_id_i), .ALUOp_o(ALUOp_id_i),
        .pc_o(pc_id_i), .inst_o(inst_id_i), .rd_o(rd_id_i), .WriteData_o(WriteData_id_i)
    );

    Decoder uDecoder(
        .clk(clk), .rst(rst),
        .regWrite(RegWrite2_id_i),
        .inst(inst_id_i),
        .rd_i(rd_id_i),
        .writeData(WriteData_id_i),
        .rs1Data(rs1Data_id_o), .rs2Data(rs2Data_id_o),
        .rd_o(rd_id_o),
        .imm32(imm32_id_o)
    );

    HazardDetector uHazardDetector(
        .clk(clk), .rst(rst && ~doBranch_ex_o),
        .inst(inst_id_i),
        .stall(stall),
        .forwarding_EX_EX1(fwd_ex_1_id_o), .forwarding_EX_EX2(fwd_ex_2_id_o),
        .forwarding_MEM_EX1(fwd_mem_1_id_o), .forwarding_MEM_EX2(fwd_mem_2_id_o)
    );

    IDBuffer uIDBuffer(
        .clk(clk), .rst(rst), .clear(stall || doBranch_ex_o),
        .fwd_ex_1(fwd_ex_1_id_o), .fwd_mem_1(fwd_mem_1_id_o),
        .fwd_ex_2(fwd_ex_2_id_o), .fwd_mem_2(fwd_mem_2_id_o),
        .fwd_ex_data(ALUResult_ex_o), .fwd_mem_data(MemData_mem_o),
        .MemRead_i(Memread_id_i), .MemtoReg_i(MemtoReg_id_i), .MemWrite_i(MemWrite_id_i), .RegWrite_i(RegWrite1_id_i),
        .ALUSrc_i(ALUSrc_id_i), .ALUOp_i(ALUOp_id_i),
        .rs1Data_i(rs1Data_id_o), .rs2Data_i(rs2Data_id_o), .imm32_i(imm32_id_o), .pc_i(pc_id_i), .inst(inst_id_i),
        .rd_i(rd_id_o),
        .MemRead_o(MemRead_ex_i), .MemtoReg_o(MemtoReg_ex_i), .MemWrite_o(MemWrite_ex_i), .RegWrite_o(RegWrite_ex_i),
        .ALUSrc_o(ALUSrc_ex_i), .ALUOp_o(ALUOp_ex_i),
        .rs1Data_o(rs1Data_ex_i), .rs2Data_o(rs2Data_ex_i), .imm32_o(imm32_ex_i), .pc_o(pc_ex_i),
        .func3(func3_ex_i), .func7(func7_ex_i),
        .rd_o(rd_ex_i)
    );

    ALU uALU(
        .ALUOp(ALUOp_ex_i),
        .ReadData1(rs1Data_ex_i), .ReadData2(rs2Data_ex_i),
        .pc(pc_ex_i), .imm32(imm32_ex_i),
        .funct3(func3_ex_i), .funct7(func7_ex_i),
        .ALUSrc(ALUSrc_ex_i),
        .ALUResult(ALUResult_ex_o), .jmp(jmp_ex_o), .doBranch(doBranch_ex_o)
    );

    EXBuffer uEXBuffer(
        .clk(clk), .rst(rst),
        .MemRead_i(MemRead_ex_i), .MemtoReg_i(MemtoReg_ex_i), .MemWrite_i(MemWrite_ex_i), .RegWrite_i(RegWrite_ex_i),
        .ALUResult_i(ALUResult_ex_o), .MemData_i(rs2Data_ex_i),
        .rd_i(rd_ex_i),
        .MemRead_o(MemRead_mem_i), .MemtoReg_o(MemtoReg_mem_i), .MemWrite_o(MemWrite_mem_i), .RegWrite_o(RegWrite_mem_i),
        .ALUResult_o(ALUResult_mem_i), .MemData_o(MemData_mem_i),
        .rd_o(rd_mem_i)
    );

    MEM uMEM(
        .clk(clk), .rst(rst),
        .MemRead(MemRead_mem_i), .MemWrite(MemWrite_mem_i), .MemtoReg(MemtoReg_mem_i),
        .ALUResult(ALUResult_mem_i), .DataIn(MemData_mem_i),
        .DataOut(MemData_mem_o)
    );

endmodule