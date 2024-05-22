`timescale 1ns/1ps

module MEM (
    input clk, rst,
    input MemRead,
    input MemWrite,
    input MemtoReg,
    input [31:0] ALUResult,
    input [31:0] DataIn,
    output reg [31:0] DataOut
);
    wire [31:0] data;
    reg [31:0] data_read;
    data_mem uram(.clka(clk), .addra(ALUResult), .dina(DataIn), .wea(MemWrite), .douta(data));

    always @(posedge clk) begin
        if (~rst || ~MemRead) data_read <= 32'b0;
        if (~rst) DataOut <= 32'b0;
        else DataOut <= MemtoReg ? data_read : ALUResult;
    end
endmodule