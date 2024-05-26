`timescale 1ns/1ps

module IFetch (
    input clk, rst,
    input stall, ecall,
    input jmp, doBranch,
    input [31:0] imm32, rs1,
    output reg [31:0] pc,
    output [31:0] inst
);
    reg lock_nop;
    wire [31:0] pc_with_nop;

    assign pc_with_nop = lock_nop ? -1 : pc;

    always @(negedge clk) begin
        lock_nop <= rst && !doBranch ? ecall : 1'b0;
        if (!rst)
            pc <= 32'b0;
        else if (jmp)
            pc <= rs1 + imm32;
        else if (stall || lock_nop)
            pc <= pc;
        else if (doBranch)
            pc <= pc - 8 + imm32;
        else
            pc <= pc + 4;
    end

    prgrom urom(.clka(clk), .addra(pc_with_nop[31:2]), .douta(inst));

endmodule