`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/19 23:43:41
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    clk, mem_addr, write_data, mem_write, mem_read
    );
    input clk;
    input [31:0] mem_addr; //in fact the max addr of memory is 20bits, allocate 32bits is to suit the bit-width of ALUResult
    input write_data;
    input [31:0] mem_write;
    output [31:0] mem_read;
    
    data_mem data_ram(.addra(mem_addr[19:0]), .clka(clk), .dina(mem_write), .douta(mem_read), .wea(write_data));
    
endmodule
