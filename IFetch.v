`timescale 1ns/1ps

module IFetch (
    input clk,
    input rst,
    input branch,
    input zero,
    input [31:0] imm32,
    output [31:0] inst
);

    reg [31:0] pc;

  
    prgrom urom(
        .clka(clk),
        .addra(pc[31:2]),
        .douta(inst)
    );

  
    always@(negedge clk) begin
        if (!rst) pc <= 32'b0;
        else begin
            if (branch && zero) pc <= pc + imm32;
            else pc <= pc + 4;
        end
    end

endmodule
