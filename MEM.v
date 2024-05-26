`timescale 1ns/1ps

module MEM ( //mem to store data
    input clk, rst,
    input MemRead,
    input MemWrite,
    input MemtoReg,
    input [31:0] ALUResult,
    input [31:0] DataIn,
    output [31:0] DataOut
);
    wire [31:0] data;
    data_mem uram(.clka(clk), .addra(ALUResult[31:2]), .dina(DataIn), .wea(MemWrite), .douta(data)); //single RAM

    wire [31:0] data_mem = (~rst || ~MemRead) ? 32'b0 : data;
    assign DataOut = rst ? (MemtoReg ? data_mem : ALUResult) : 0;
endmodule