`timescale 1ns/1ps

module Mem (
    input clk, rst,
    input MemRead,
    input MemWrite,
    input MemtoReg,
    input [31:0] ALUResult,
    input DataIn,
    output reg [31:0] DataOut
);
    wire [31:0] data;

    data_mem uram(.clka(clk), .addra(ALUResult), .dina(DataIn), .wea(MemWrite), .douta(data));

    always @(negedge clk) begin
        if (~rst || MemRead) DataOut <= 32'b0;
        else DataOut <= data;
    end
endmodule