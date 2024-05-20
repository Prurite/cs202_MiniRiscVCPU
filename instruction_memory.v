`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/14 15:14:50
// Design Name: 
// Module Name: instruction_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_memory(
    clk, inst_addr, instruction
    );
    input clk;
    input [19:0] inst_addr;
    output [31:0] instruction;
    inst_mem inst_rom(.addra(inst_addr), .clka(clk), .douta(instruction));
endmodule
