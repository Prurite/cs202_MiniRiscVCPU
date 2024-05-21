`timescale 1ns/1ps

module IFetch (
    input clk, rst,
    input stall,
    input doBranch,
    input [31:0] imm32,
    output [31:0] inst
);
    wire[31:0] inst_mem;
    reg [31:0] pc;
    always @(negedge clk) begin
        if (!rst)
            pc <= 32'b0;
        else if (stall)
            pc <= pc;
        else if (doBranch)
            pc <= pc - 4 + imm32;
        else
            pc <= pc + 4;
    end

    assign inst = stall ? 32'b0 : inst_mem;

    prgrom urom(.clka(clk), .addra(pc[31:2]), .douta(inst_mem));
endmodule