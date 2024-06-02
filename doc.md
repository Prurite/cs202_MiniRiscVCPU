# CS202 Project Mini RV32 CPU
## 硬件及开发者

硬件：EGO1开发板 xc7a35tcsg324-1

| 成员 | 工作 | 贡献比 |
| --- | --- | --- |
| 12211429 何星熠 | CPU 各模块具体功能实现 | 35%|
| 12211426 简越 | CPU 设计图绘制，测试用例汇编文件编写 | 35%|
| 12211120 迟湛铧 | 代码整理，电子管模块，硬件绑定 | 30%|

## 开发计划

### 日程安排

| 周   | 计划        | 完成情况                                                     |
| ---- | ----------- | ------------------------------------------------------------ |
| 9    | 小组见面    | 建好了群                                                     |
| 10   | 设计CPU模块 | 计划参考课本上的设计图，最终决定使用PPT绘制设计图，完成初稿以及任务分配 |
| 11   | 写代码      |                                                              |
| 12   | 写代码      |                                                              |
| 13   | 写代码      | 基本模块全部完成，还剩IO和外设，asm文件需要调整              |
| 14   | 测试        | 实现计划实现的所有功能                                       |
| 15   | 答辩        |                                                              |

### 版本修改记录

完整开发过程记录在GitHub上：

https://github.com/Prurite/cs202_MiniRiscVCPU

## CPU架构设计说明

### CPU特性

#### ISA

支持大部分标准 RV32I 指令

| Inst Name              | FMT           | Opcode  | funct3 | funct7 | Description                                  |
|------------------------|---------------|---------|--------|--------|----------------------------------------------|
| add                    | ADD           | R       | 0110011| 0x0    | 0x00    |
| sub                    | SUB           | R       | 0110011| 0x0    | 0x20    |
| xor                    | XOR           | R       | 0110011| 0x4    | 0x00    |
| or                     | OR            | R       | 0110011| 0x6    | 0x00    |
| and                    | AND           | R       | 0110011| 0x7    | 0x00    |
| sll                    | Shift Left Logical | R       | 0110011| 0x1    | 0x00    |
| srl                    | Shift Right Logical | R       | 0110011| 0x5    | 0x00    |
| sra                    | Shift Right Arith* | R       | 0110011| 0x5    | 0x20    |
| slt                    | Set Less Than | R       | 0110011| 0x2    | 0x00    |
| sltu                   | Set Less Than (U) | R       | 0110011| 0x3    | 0x00    |
| addi                   | ADD Immediate | I       | 0010011| 0x0    |         |
| xori                   | XOR Immediate | I       | 0010011| 0x4    |         |
| ori                    | OR Immediate  | I       | 0010011| 0x6    |         |
| andi                   | AND Immediate | I       | 0010011| 0x7    |         |
| slli                   | Shift Left Logical Imm | I  | 0010011| 0x1    | imm[11:5]=0x00 |
| srli                   | Shift Right Logical Imm | I  | 0010011| 0x5    | imm[11:5]=0x00 |
| srai                   | Shift Right Arith Imm | I  | 0010011| 0x5    | imm[11:5]=0x20 |
| slti                   | Set Less Than Imm | I    | 0010011| 0x2    |         |
| sltiu                  | Set Less Than Imm (U) | I  | 0010011| 0x3    |         |
| lw                     | Load Word     | I       | 0000011| 0x2    |         |
| sw                     | Store Word    | S       | 0100011| 0x2    |         |
| beq                    | Branch ==     | B       | 1100011| 0x0    |         |
| bne                    | Branch !=     | B       | 1100011| 0x1    |         |
| blt                    | Branch <      | B       | 1100011| 0x4    |         |
| bge                    | Branch ≥      | B       | 1100011| 0x5    |         |
| bltu                   | Branch < (U)  | B       | 1100011| 0x6    |         |
| bgeu                   | Branch ≥ (U)  | B       | 1100011| 0x7    |         |
| jal                    | Jump And Link | J       | 1101111|        |         |
| jalr                   | Jump And Link Reg | I   | 1100111| 0x0    |         |
| lui                    | Load Upper Imm | U      | 0110111|        |         |
| auipc                  | Add Upper Imm to PC | U | 0010111|        |         |
| ecall*                 | Environment Call | I   | 1110011| 0x0    | imm=0x0 |

*`ecall` 只支持部分 IO 调用，详见“对外设 IO 的支持”。

#### 寄存器

共 32 个，位宽 32bit ，编号为 x0 – x31，其中 x3(sp) 初始化为 65536 ， 其余初始化为 0 。

#### CPU时钟

多周期，支持 pipeline，五级流水。正常指令一条需 5 个周期，由于 5 级流水线，在不存在需 stall 的 hazard 时，CPI 为 1。采用转发（forwarding）、分支预测以及挂起（stall）方式解决流水线冲突。

#### 寻址空间设计

哈佛结构；最小寻址单位 1 word / 4 bytes ，指令空间 16384 words / 65536 bytes，数据空间 16384 words / 65536 bytes，栈空间基地址 65536 。

#### 对外设 IO 的支持

采用 `ecall` 指令，及 a0, a7 寄存器中的参数进行 IO ，IO 中断结束后返回值（如有）存于 a0 中。

a7 支持的参数：1，以 16 进制输出 a0 中的 32 位整数到数码管；5，从拨码开关读入 8 位二进制数至 a0 的低 8 位）。

### CPU接口

#### 时钟

```verilog
set_property PACKAGE_PIN P17 [get_ports clk_hw]  
```

#### 复位

```verilog
set_property PACKAGE_PIN P15 [get_ports rst] 
```

#### 其他常用IO接口

```verilog
# IO proceed button

set_property PACKAGE_PIN R11 [get_ports Button]

# Switches are mapped to IO input 

set_property PACKAGE_PIN P5 [get_ports {Switches[7]}]
set_property PACKAGE_PIN P4 [get_ports {Switches[6]}]
set_property PACKAGE_PIN P3 [get_ports {Switches[5]}]
set_property PACKAGE_PIN P2 [get_ports {Switches[4]}]
set_property PACKAGE_PIN R2 [get_ports {Switches[3]}]
set_property PACKAGE_PIN M4 [get_ports {Switches[2]}]
set_property PACKAGE_PIN N4 [get_ports {Switches[1]}]
set_property PACKAGE_PIN R1 [get_ports {Switches[0]}]

# 7-segment displays (selection)

set_property PACKAGE_PIN G2 [get_ports {an[7]}]
set_property PACKAGE_PIN C2 [get_ports {an[6]}]
set_property PACKAGE_PIN C1 [get_ports {an[5]}]
set_property PACKAGE_PIN H1 [get_ports {an[4]}]
set_property PACKAGE_PIN G1 [get_ports {an[3]}]
set_property PACKAGE_PIN F1 [get_ports {an[2]}]
set_property PACKAGE_PIN E1 [get_ports {an[1]}]
set_property PACKAGE_PIN G6 [get_ports {an[0]}]

# 7-segment displays (tubes)

set_property PACKAGE_PIN B4 [get_ports {seg[7]}]
set_property PACKAGE_PIN A4 [get_ports {seg[6]}]
set_property PACKAGE_PIN A3 [get_ports {seg[5]}]
set_property PACKAGE_PIN B1 [get_ports {seg[4]}]
set_property PACKAGE_PIN A1 [get_ports {seg[3]}]
set_property PACKAGE_PIN B3 [get_ports {seg[2]}]
set_property PACKAGE_PIN B2 [get_ports {seg[1]}]
set_property PACKAGE_PIN D5 [get_ports {seg[0]}]

set_property PACKAGE_PIN D4 [get_ports {seg1[7]}]
set_property PACKAGE_PIN E3 [get_ports {seg1[6]}]
set_property PACKAGE_PIN D3 [get_ports {seg1[5]}]
set_property PACKAGE_PIN F4 [get_ports {seg1[4]}]
set_property PACKAGE_PIN F3 [get_ports {seg1[3]}]
set_property PACKAGE_PIN E2 [get_ports {seg1[2]}]
set_property PACKAGE_PIN D2 [get_ports {seg1[1]}]
set_property PACKAGE_PIN H2 [get_ports {seg1[0]}]

# IO wait status lights

set_property PACKAGE_PIN J2 [get_ports EcallWait]
set_property PACKAGE_PIN K2 [get_ports InputWait]
```

### CPU 内部结构

##### **接口和关系图**

![2ebaa03fffbc86eee64010d3791d4c82](assets/2ebaa03fffbc86eee64010d3791d4c82.jpg)

##### **子模块设计说明**

```verilog
wire clk;

wire [31:0] SegData;

wire [31:0] inst_if_o, pc_if_o;

wire MemRead_if_o, MemtoReg_if_o, MemWrite_if_o, RegWrite_if_o, Ecall_if_o;
wire [1:0] ALUSrc_if_o;
wire [3:0] ALUOp_if_o;

wire Memread_id_i, MemtoReg_id_i, MemWrite_id_i, RegWrite1_id_i, RegWrite2_id_i, Ecall_id_i;
wire [1:0] ALUSrc_id_i;
wire [3:0] ALUOp_id_i;
wire [4:0] rd_id_i;
wire [31:0] inst_id_i, pc_id_i, WriteData_id_i;

wire [31:0] rs1Data_id_o, rs2Data_id_o, imm32_id_o;
wire [4:0] rd_id_o;
wire fwd_ex_1_id_o, fwd_ex_2_id_o, fwd_mem_1_id_o, fwd_mem_2_id_o;

wire MemRead_ex_i, MemtoReg_ex_i, MemWrite_ex_i, RegWrite_ex_i, Ecall_ex_i;
wire [1:0] ALUSrc_ex_i;
wire [3:0] ALUOp_ex_i;
wire [31:0] rs1Data_ex_i, rs2Data_ex_i, imm32_ex_i, pc_ex_i;
wire [2:0] func3_ex_i;
wire [6:0] func7_ex_i;
wire [4:0] rd_ex_i;

wire [31:0] ALUResult_ex_o, EcallResult_ex_o;
wire jmp_ex_o, doBranch_ex_o, EcallWrite_ex_o, EcallDone_ex_o;

wire MemRead_mem_i, MemtoReg_mem_i, MemWrite_mem_i, RegWrite_mem_i;
wire [31:0] ALUResult_mem_i, MemData_mem_i;
wire [4:0] rd_mem_i;

wire [31:0] MemData_mem_o;

wire stall;

clk_wiz_0 uClkWiz(.clk_in1(clk_hw), .clk_out1(clk));

IFetch uIFetch(
        .clk(clk), .rst(rst), .stall(stall), .ecall(Ecall_if_o),
    .jmp(jmp_ex_o), .doBranch(doBranch_ex_o), // may have mistake when the clock is too fast(>50MHz)
        .imm32(imm32_ex_i), .rs1(rs1Data_ex_i), //db and imm are prepared at pos and used at neg
        .pc(pc_if_o),
        .inst(inst_if_o)
    );

    Controller uController(
        .clk(clk), .rst(rst),
        .inst(inst_if_o),
        .EcallDone(EcallDone_ex_o), .doBranch(doBranch_ex_o),
        .MemRead(MemRead_if_o), .MemtoReg(MemtoReg_if_o), .MemWrite(MemWrite_if_o),
        .RegWrite(RegWrite_if_o), .Ecall(Ecall_if_o),
        .ALUSrc(ALUSrc_if_o),
        .ALUOp(ALUOp_if_o)
    );

    IFBuffer uIFBuffer(
        .clk(clk), .rst(rst), .stall(stall), .clear(doBranch_ex_o || EcallDone_ex_o),// branch or ecall need to clear the pipeline
        .MemRead_i(MemRead_if_o), .MemtoReg_i(MemtoReg_if_o), .MemWrite_i(MemWrite_if_o),
        .ALUSrc_i(ALUSrc_if_o), .RegWrite1_i(RegWrite_if_o), .RegWrite2_i(RegWrite_mem_i), .ALUOp_i(ALUOp_if_o),
        .ecall_i(Ecall_if_o),
        .pc_i(pc_if_o), .inst_i(inst_if_o), .rd_i(rd_mem_i), .WriteData_i(MemData_mem_o),
        .MemRead_o(Memread_id_i), .MemtoReg_o(MemtoReg_id_i), .MemWrite_o(MemWrite_id_i),
        .ALUSrc_o(ALUSrc_id_i), .RegWrite1_o(RegWrite1_id_i), .RegWrite2_o(RegWrite2_id_i), .ALUOp_o(ALUOp_id_i),
        .ecall_o(Ecall_id_i),
        .pc_o(pc_id_i), .inst_o(inst_id_i), .rd_o(rd_id_i), .WriteData_o(WriteData_id_i)
    );

    Decoder uDecoder(
        .clk(clk), .rst(rst),
        .regWrite(RegWrite2_id_i), .EcallWrite(EcallWrite_ex_o),
        .inst(inst_id_i),
        .rd_i(rd_id_i),
        .writeData(WriteData_id_i), .EcallResult(EcallResult_ex_o),
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
        .clk(clk), .rst(rst), .clear(stall || doBranch_ex_o || EcallDone_ex_o), //receive stall/doBranch/EcallDone, need to clear the pipeline
        .fwd_ex_1(fwd_ex_1_id_o), .fwd_mem_1(fwd_mem_1_id_o),
        .fwd_ex_2(fwd_ex_2_id_o), .fwd_mem_2(fwd_mem_2_id_o),
        .fwd_ex_data(ALUResult_ex_o), .fwd_mem_data(MemData_mem_o),
        .MemRead_i(Memread_id_i), .MemtoReg_i(MemtoReg_id_i), .MemWrite_i(MemWrite_id_i), .RegWrite_i(RegWrite1_id_i),
        .ecall_i(Ecall_id_i),
        .ALUSrc_i(ALUSrc_id_i), .ALUOp_i(ALUOp_id_i),
        .rs1Data_i(rs1Data_id_o), .rs2Data_i(rs2Data_id_o), .imm32_i(imm32_id_o), .pc_i(pc_id_i), .inst(inst_id_i),
        .rd_i(rd_id_o),
        .MemRead_o(MemRead_ex_i), .MemtoReg_o(MemtoReg_ex_i), .MemWrite_o(MemWrite_ex_i), .RegWrite_o(RegWrite_ex_i),
        .ecall_o(Ecall_ex_i),
        .ALUSrc_o(ALUSrc_ex_i), .ALUOp_o(ALUOp_ex_i),
        .rs1Data_o(rs1Data_ex_i), .rs2Data_o(rs2Data_ex_i), .imm32_o(imm32_ex_i), .pc_o(pc_ex_i),
        .func3(func3_ex_i), .func7(func7_ex_i),
        .rd_o(rd_ex_i)
    );

    IOHandler uIOHandler (
        .clk(clk), .rst(rst), .Ecall(Ecall_ex_i),
        .switches(Switches), .button(Button),
        .a0(rs1Data_ex_i), .a7(rs2Data_ex_i),
        .EcallDone(EcallDone_ex_o), .EcallWrite(EcallWrite_ex_o),
        .EcallWait(EcallWait), .needWrite(InputWait),
        .EcallResult(EcallResult_ex_o),
        .SegData(SegData)
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

    DigitalTube uTube(
        .clk(clk_hw), .rst(rst),
        .show_data(SegData),
        .seg(seg), .seg1(seg1), .an(an)
    );
```

## 系统上板使用说明

### 输入

复位使用 EGO1 上的 reset 拨钮，按下后 CPU 所有参数重置为初始状态。

当代码使用 ecall 调用 IO 读入时，CPU 会进入等待用户输入状态，IO 等待及输入等待灯亮。用户通过拨码开关完成输入后，按下 IO 确定按钮，系统将读入的结果传入 a0 寄存器，程序继续执行。

### 输出

当代码使用 ecall 调用 IO 输出时，CPU 会将 a0 中的数据显示在数码管上，并进入等待用户确认输出状态，IO 等待灯亮。用户需要继续程序执行时，按下 IO 确定按钮，程序继续执行。

## **自测试说明**





## **问题及总结**

 实际任务分配存在与前期规划不符的问题，应该加强任务分配上的沟通，减少任务冲突。

 **Bonus**

## 基于RISC-V32I的ISA实现pipeline

通过引入doBranch、stall信号，以及IFBuffer、IDBuffer、EXBuffer等模块，实现数据在模块间的存取以及涉及寄存器冲突时的异常处理；同时为了避免内存存取的冲突采用哈佛结构。

### HazardDetector核心代码

```verilog
module HazardDetector(
	input clk, rst,
	input [31:0] inst,
	output reg stall,
	output reg forwarding_EX_EX1,
	output reg forwarding_EX_EX2,
	output reg forwarding_MEM_EX1,
	output reg forwarding_MEM_EX2
);
    // define parameter
    localparam J     = 7'b110x111;
    localparam U     = 7'b0x10111;
    localparam LOAD  = 7'b0000011;
    localparam R     = 7'b0110011;
    localparam I     = 7'b00x0011; 
    localparam ECALL = 7'b1110011;

    reg [31:0] preInst1, preInst2;

`define op inst[6:0]
`define pre1op preInst1[6:0]
`define pre2op preInst2[6:0]
`define rs1 (`op == 7'b1110011 ? 5'd10 : inst[19:15])
`define rs2 (`op == 7'b1110011 ? 5'd17 : inst[24:20])
`define rd inst[11:7]
`define pre1rd preInst1[11:7]
`define pre2rd preInst2[11:7]

    always @(negedge clk) begin
        if (~rst) begin
            preInst1 <= 32'b0;
            preInst2 <= 32'b0;
        end else begin
            preInst1 <= stall ? 32'b0 : inst;
            preInst2 <= preInst1;
        end
    end

/*
Stall: 连续两条指令，pre1 lw 的 rd 是 cur 的 rs1 / rs2
EX-EX: 连续两条指令，pre1 不是 lw 的 rd 是 cur 的 rs1 / rs2
MEM-EX：pre2 指令的 rd 是 cur 的 rs1 / rs2
*/

	wire pre1 = `pre1op == R || `pre1op ==? I || `pre1op ==? J || `pre1op ==? U;
	wire pre2 = `pre2op == LOAD || `pre2op == R || `pre2op ==? I || `pre2op ==? J || `pre2op ==? U;

	always @(posedge clk) begin
		if (~rst) begin
			stall <= 1'b0;
			forwarding_EX_EX1 <= 1'b0;
			forwarding_MEM_EX1 <= 1'b0;
			forwarding_EX_EX2 <= 1'b0;
			forwarding_MEM_EX2 <= 1'b0;
		end else begin
			stall <= `pre1op == LOAD && (`pre1rd == `rs1 || `pre1rd == `rs2);
			forwarding_EX_EX1 <= pre1 && (`pre1rd == `rs1);
			forwarding_MEM_EX1 <= pre2 && (`pre2rd == `rs1);
			forwarding_EX_EX2 <= pre1 && (`pre1rd == `rs2);
			forwarding_MEM_EX2 <= pre2 && (`pre2rd == `rs2);
		end
	end

endmodule
```

### IFBuffer核心代码

```verilog
`timescale 1ns/1ps

module IFBuffer( //buffer between IF and ID, use to implete pipeline
  input clk, rst, stall, clear,
  input MemRead_i, MemtoReg_i, MemWrite_i, RegWrite1_i, RegWrite2_i, ecall_i,
  input [1:0] ALUSrc_i,
  input [3:0] ALUOp_i, 
  input [31:0] pc_i, inst_i,
  input [4:0] rd_i,
  input [31:0] WriteData_i,
  output reg MemRead_o, MemtoReg_o, MemWrite_o, RegWrite1_o, RegWrite2_o, ecall_o,
  output reg [1:0] ALUSrc_o,
  output reg [3:0] ALUOp_o, 
  output reg [31:0] pc_o, inst_o,
  output reg [4:0] rd_o,
  output reg [31:0] WriteData_o
);
  always @(negedge clk) begin
    WriteData_o <= rst ? WriteData_i : 32'b0;
    rd_o <= rst ? rd_i : 32'b0;
    RegWrite2_o <= rst ? RegWrite2_i : 32'b0;

    if (!rst || clear) begin
      MemRead_o <= 1'b0;
      MemtoReg_o <= 1'b0;
      MemWrite_o <= 1'b0;
      ALUSrc_o <= 2'b0;
      ALUOp_o <= 4'b0;
      RegWrite1_o <= 1'b0;
      pc_o <= 32'b0;
      inst_o <= 32'b0;
      ecall_o <= 1'b0;
    end else if (stall) begin
      MemRead_o <= MemRead_o;
      MemtoReg_o <= MemtoReg_o;
      MemWrite_o <= MemWrite_o;
      ALUSrc_o <= ALUSrc_o;
      ALUOp_o <= ALUOp_o;
      RegWrite1_o <= RegWrite1_o;
      pc_o <= pc_o;
      inst_o <= inst_o;
      ecall_o <= ecall_o;
    end else begin
      MemRead_o <= MemRead_i;
      MemtoReg_o <= MemtoReg_i;
      MemWrite_o <= MemWrite_i;
      ALUSrc_o <= ALUSrc_i;
      ALUOp_o <= ALUOp_i;
      RegWrite1_o <= RegWrite1_i;
      pc_o <= pc_i;
      inst_o <= inst_i;
      ecall_o <= ecall_i;
    end
  end
endmodule
```



### IDBuffer核心代码

负责ID与EX间信号的传递

```verilog
`timescale 1ns/1ps

module IDBuffer ( //buffer between ID and EX, use to implete pipeline
  input clk, rst, clear,
  input fwd_ex_1, fwd_mem_1, fwd_ex_2, fwd_mem_2,
  input [31:0] fwd_ex_data, fwd_mem_data,
  input MemRead_i, MemtoReg_i, MemWrite_i, RegWrite_i, ecall_i,
  input [1:0] ALUSrc_i,
  input [3:0] ALUOp_i,
  input [31:0] rs1Data_i, rs2Data_i, imm32_i, pc_i, inst,
  input [4:0] rd_i,
  output reg MemRead_o, MemtoReg_o, MemWrite_o, RegWrite_o, ecall_o,
  output reg [1:0] ALUSrc_o,
  output reg [3:0] ALUOp_o,
  output reg [31:0] rs1Data_o, rs2Data_o, imm32_o, pc_o,
  output reg [2:0] func3,
  output reg [6:0] func7,
  output reg [4:0] rd_o
);
  assign neg_r = rst && !clear;

  always @(negedge clk) begin //neg_r -> clear; else -> stall
    MemRead_o <= neg_r ? MemRead_i : 1'b0;
    MemtoReg_o <= neg_r ? MemtoReg_i : 1'b0;
    MemWrite_o <= neg_r ? MemWrite_i : 1'b0;
    RegWrite_o <= neg_r ? RegWrite_i : 1'b0;
    ALUSrc_o <= neg_r ? ALUSrc_i : 2'b0;
    ALUOp_o <= neg_r ? ALUOp_i : 4'b0;
    imm32_o <= neg_r ? imm32_i : 32'b0;
    pc_o <= neg_r ? pc_i : 32'b0;
    func3 <= neg_r ? inst[14:12] : 3'b0;
    func7 <= neg_r ? inst[31:25] : 7'b0;
    rd_o <= neg_r ? rd_i : 5'b0;
    ecall_o <= neg_r ? ecall_i : 1'b0;
  end

    always @(negedge clk) begin //reset or continue
    if (!neg_r)
      rs1Data_o <= 32'b0;
    else if (fwd_ex_1)
      rs1Data_o <= fwd_ex_data;
    else if (fwd_mem_1)
      rs1Data_o <= fwd_mem_data;
    else
      rs1Data_o <= rs1Data_i;
    if (!neg_r)
      rs2Data_o <= 32'b0;
    else if (fwd_ex_2)
      rs2Data_o <= fwd_ex_data;
    else if (fwd_mem_2)
      rs2Data_o <= fwd_mem_data;
    else
      rs2Data_o <= rs2Data_i;
  end
endmodule
```

### EXBuffer核心代码

```verilog
`timescale 1ns/1ps

module EXBuffer( //buffer between EX and MEM, use to implete pipeline
  input clk, rst,
  input MemRead_i, MemtoReg_i, MemWrite_i, RegWrite_i,
  input [31:0] ALUResult_i, MemData_i,
  input [4:0] rd_i,
  output reg MemRead_o, MemtoReg_o, MemWrite_o, RegWrite_o,
  output reg [31:0] ALUResult_o, MemData_o,
  output reg [4:0] rd_o
);
  always @(negedge clk) begin //clear or output
    MemRead_o <= rst ? MemRead_i : 1'b0;
    MemtoReg_o <= rst ? MemtoReg_i : 1'b0;
    MemWrite_o <= rst ? MemWrite_i : 1'b0;
    RegWrite_o <= rst ? RegWrite_i : 1'b0;
    ALUResult_o <= rst ? ALUResult_i : 32'b0;
    MemData_o <= rst ? MemData_i : 32'b0;
    rd_o <= rst ? rd_i : 5'b0;
  end
endmodule 

```

### 测试场景：

采用存在冲突的asm文件，利用波形图观察信号是否正确处理以及传递

### 测试用例：

##### 汇编代码：

```assembly
Case3_1:
    li a1, 5
    li a2, 2
    sub a0, a1, a2

Case3_2:
    li a1, 5
    sw a1, -4(sp)
    lw a2, -4(sp)
    addi a2, a2, 7
    mv a0, a2

Case3_3:
    li t1, 17
    li t2, 6
    sub t3, t1, t2
    and t4, t1, t3
    xor a0, t3, t4
```

##### 仿真1：

```verilog
`timescale 1ns / 1ps

module sim_1;


  // Inputs
  reg clk;
  reg rst;
  // Outputs


  // Instantiate the Unit Under Test (UUT)
  main umain (
    .clk(clk),
    .rst(rst)
  );

  // Initialize inputs
  initial begin
    clk = 1'b0;
    rst = 1'b0;
    #17 rst = ~rst;
  end

  // Stimulus
  always begin
    repeat(500) #5 clk = ~clk;
    #10 $finish;

  end




  // Monitor

endmodule
```

##### 仿真2：

```verilog
`timescale 1ns/1ps
module sim_2;
    reg clk;
    reg rst;
    reg [7:0] switches;
    reg button;
    main umain(.clk_hw(clk), .rst(rst), .Switches(switches), .Button(button));

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        switches = 8'b0000_0010;
        button = 1'b0;
        #17 rst = ~rst;
    end

    always begin
        repeat(500) #5 clk = ~clk;
        #10 $finish;
    end

    always begin
        #50 button = 1'b1;
        #50 button = 1'b0;
    end

endmodule
```



### 测试结果：

（需要hazard仿真图片）

## 实现现有RISC-V32I 的ISA中的 lui，aupic，ecal l

lui、auipc由硬件实现；

ecall实现读取、输出功能，硬件由拨码开关输入具体数值，R11按钮确认输入，电子管显示a0存入的数值

### 指令处理代码：

译码器，lui、auipc相关

```verilog
//decoder and distribution
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
end

```

Controller，涉及信号分发

```verilog
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

    always @(posedge clk) //branch process
        prevDoBranch <= doBranch;

    always @(posedge clk) //'system call' process, wait for the previous system call to finish
        if (EcallDone || !rst || doBranch || prevDoBranch) //play as stop
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
```

ALU，涉及移位以及高位运算

```verilog
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
```



IOHandler，ecall相关

```verilog
`timescale 1ns/1ps

module IOHandler ( //process input from terminal and output to display module
	input clk, rst, Ecall,
	input [7:0] switches,
	input button,
	input [31:0] a0, a7,
	output reg EcallDone, EcallWrite, EcallWait, needWrite,
	output reg [31:0] EcallResult,
	output reg [31:0] SegData
);
	reg slowPrevButton, fastPrevButton;
	wire clk_slow;

	ClkDiv uClkDiv(.clk(clk), .rst(rst), .clk_o(clk_slow));

	always @(posedge clk_slow) //use slow clock to debounce button
		slowPrevButton <= button;

	always @(posedge clk) //detect the change of button
		fastPrevButton <= slowPrevButton;

	always @(posedge clk) begin //ecalldone, ecallwrite, ecallwait, denote the state of system call
		if (!rst) begin
			{ EcallWait, EcallDone, EcallWrite, needWrite } <= 4'b0;
			SegData <= 32'b0;
		end
		else if (EcallDone)
			{ EcallWrite, EcallDone } <= 1'b0;
		else if (Ecall && !EcallWait) begin
			EcallWait <= 1'b1;
			SegData <= a7 == 32'd1 ? a0 : 32'd0; // output
			needWrite <= a7 == 32'd5;
		end else if (EcallWait && !fastPrevButton && slowPrevButton) begin
			EcallWait <= 1'b0;
			EcallDone <= 1'b1;
			EcallWrite <= needWrite;
			EcallResult <= needWrite ? {24'b0, switches} : 32'd0; // input
		end else begin
			EcallWait <= EcallWait;
			EcallDone <= EcallDone;
			EcallWrite <= EcallWrite;
			needWrite <= needWrite;
			SegData <= SegData;
		end
	end
endmodule
```





# 特别鸣谢

