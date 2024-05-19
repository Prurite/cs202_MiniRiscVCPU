`timescale 1ns/1ps

module IFetch (
    input clk, rst,
    input [31:0] imm32,
    input branch, zero,
    output [31:0] inst
);
    reg [31:0] pc;
    always @(negedge clk) begin
        if (!rst)
            pc <= 32'b0;
        else if (branch && zero)
            pc <= pc + imm32;
        else
            pc <= pc + 4;
    end
    prgrom urom(.clka(clk), .addra(pc[31:2]), .douta(inst));
endmodule