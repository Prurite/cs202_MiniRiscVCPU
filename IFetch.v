`timescale 1ns/1ps

module IFetch (
    input clk, rst,
    input stall,
    input jmp, doBranch,
    input [31:0] imm32, rs1,
    output reg [31:0] pc,
    output [31:0] inst
);
    always @(negedge clk) begin
        if (!rst)
            pc <= 32'b0;
        else if (jmp)
            pc <= rs1 + imm32;
        else if (stall)
            pc <= pc;
        else if (doBranch)
            pc <= pc - 8 + imm32;
        else
            pc <= pc + 4;
    end


    prgrom urom(.clka(clk), .addra(pc[31:2]), .douta(inst));
endmodule