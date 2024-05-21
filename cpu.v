`timescale 1ns/1ps

module cpu (
    input clk, rst
);

    wire stall;
    wire forwarding_EX_EX1;
    wire forwarding_EX_EX2;
    wire forwarding_MEM_EX1;
    wire forwarding_MEM_EX2;
    wire incorrect;

    wire[31:0] inst_IFetch;

    wire[31:0] imm32_Decoder;
    IFetch ifetch(
        .clk(clk), .rst(rst),
        .stall(stall),
        .incorrect(incorrect),
        .imm32(imm32_Decoder),
        .inst(inst_IFetch)
    );

    wire MemRead_Controller;
    wire MemtoReg_Controller;
    wire MemWrite_Controller;
    wire ALUSrc_Contorller;
    wire [1:0] ALUOp_Controller;


    wire RegWrite_Controller;

    Controller controller(
        .inst(inst_IFetch),
        .MemRead(MemRead_Controller),
        .MemtoReg(MemtoReg_Controller),
        .MemWrite(MemWrite_Controller),
        .ALUSrc(ALUSrc_Contorller),
        .RegWrite(RegWrite_Controller),
        .ALUOp(ALUOp_Controller)
    );

    wire[31:0] WriteData_Mem;//will be passed from mem
    wire[31:0] rs1Data_Decoder;
    wire[31:0] rs2Data_Decoder;


    Decoder decoder (
        .clk(clk), .rst(rst),
        .regWrite(RegWrite_Controller),
        .inst(inst_IFetch),
        .writeData(WriteData_Mem),
        .rs1Data(rs1Data_Decoder),
        .rs2Data(rs2Data_Decoder),
        .imm32(imm32_Decoder),
        .incorrect(incorrect)
    );

    Hazard hazard (
        .clk(clk), .rst(rst),
        .inst(inst_IFetch),
        .stall(stall),
        .forwarding_EX_EX1(forwarding_EX_EX1),
        .forwarding_EX_EX2(forwarding_EX_EX2),
        .forwarding_MEM_EX1(forwarding_MEM_EX1),
        .forwarding_MEM_EX2(forwarding_MEM_EX2)
    );

    reg MemRead_r2;
    reg MemtoReg_r2;
    reg MemWrite_r2;
    reg ALUSrc_r2;
    reg [1:0] ALUOp_r2;
    reg [2:0] funct3_r2;
    reg [6:0] funct7_r2;

    reg [32:0] imm32_r2;
    reg [31:0] ReadData1;
    reg [31:0] ReadData2;

    always @(posedge clk) begin
        if (~rst || stall) begin
            MemRead_r2 <= 1'b0;
            MemtoReg_r2 <= 1'b0;
            MemWrite_r2 <= 1'b0;
            ALUSrc_r2 <= 1'b0;
            ALUOp_r2 <= 2'b0;
            funct3_r2 <= 3'b0;
            funct7_r2 <= 7'b0;
            imm32_r2 <= 32'b0;
            ReadData1 <= 32'b0;
            ReadData2 <= 32'b0;
        end
        else begin
            MemRead_r2 <= MemRead_Controller;
            MemtoReg_r2 <= MemtoReg_Controller;
            MemWrite_r2 <= MemWrite_Controller;
            ALUSrc_r2 <= ALUSrc_Contorller;
            ALUOp_r2 <= ALUOp_Controller;
            imm32_r2 <= imm32_Decoder;
            funct3_r2 <= inst_IFetch[14:12];
            funct7_r2 <= inst_IFetch[31:25];

            if (forwarding_EX_EX1) ReadData1 <= ALUResult_ALU;
            else if (forwarding_MEM_EX1) ReadData1 <= WriteData_Mem;
            else ReadData1 <= rs1Data_Decoder;

            if (forwarding_EX_EX2) ReadData2 <= ALUResult_ALU;
            else if (forwarding_MEM_EX2) ReadData2 <= WriteData_Mem;
            else ReadData2 <= rs2Data_Decoder;
        end
    end

    wire [31:0] ALUResult_ALU;

    ALU alu (
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .imm32(imm32_r2),
        .ALUOp(ALUOp_r2),
        .funct3(funct3_r2),
        .funct7(funct7_r2),
        .ALUSrc(ALUSrc_r2)
    );

    reg MemRead_r3;
    reg MemtoReg_r3;
    reg MemWrite_r3;

    reg[31:0] DataIn_r3;

    always @(posedge clk) begin
        if (~rst) begin
            MemRead_r3 <= 1'b0;
            MemtoReg_r3 <= 1'b0;
            MemWrite_r3 <= 1'b0;
            DataIn_r3 <= 32'b0;
        end
        else begin
            MemRead_r3 <= MemRead_r2;
            MemtoReg_r3 <= MemtoReg_r2;
            MemWrite_r3 <= MemWrite_r2;
            DataIn_r3 <= ReadData2;
        end

    end

    MEM mem (
        .clk(clk), .rst(rst),
        .MemRead(MemtoReg_r3),
        .MemWrite(MemWrite_r3),
        .MemtoReg(MemtoReg_r3),
        .ALUResult(ALUResult_ALU),
        .DataIn(DataIn_r3),
        .DataOut(WriteData_Mem)
    );
endmodule