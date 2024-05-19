`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/19 23:01:54
// Design Name: 
// Module Name: registers
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


module registers(
    clk, reset,
    rs1, rs2, rd, write_data, reg_write, 
    read_data1, read_data2
    );
    input clk, reset;
    input [4:0] rs1; 
    input [4:0] rs2;
    input [4:0] rd;
    input write_data;
    input [31:0] reg_write;
    output reg [31:0] read_data1;
    output reg [31:0] read_data2;
    
    reg [31:0] registers [31:0];
    initial begin
        registers[0] = 32'h0000;
        registers[1] = 32'h0000;
        registers[2] = 32'hffff;
        registers[3] = 32'h0000;
        registers[4] = 32'h0000;
        registers[5] = 32'h0000;
        registers[6] = 32'h0000;
        registers[7] = 32'h0000;
        registers[8] = 32'h0000;
        registers[9] = 32'h0000;
        registers[10] = 32'h0000;
        registers[11] = 32'h0000;
        registers[12] = 32'h0000;
        registers[13] = 32'h0000;
        registers[14] = 32'h0000;
        registers[15] = 32'h0000;
        registers[16] = 32'h0000;
        registers[17] = 32'h0000;
        registers[18] = 32'h0000;
        registers[19] = 32'h0000;
        registers[20] = 32'h0000;
        registers[21] = 32'h0000;
        registers[22] = 32'h0000;
        registers[23] = 32'h0000;
        registers[24] = 32'h0000;
        registers[25] = 32'h0000;
        registers[26] = 32'h0000;
        registers[27] = 32'h0000;
        registers[28] = 32'h0000;
        registers[29] = 32'h0000;
        registers[30] = 32'h0000;
        registers[31] = 32'h0000; 
    end
    
    always @(*) begin   //read register
        if (reset == 1'b1) begin
            read_data1 <= 32'h0000;
            read_data2 <= 32'h0000;
        end
        else begin
            read_data1 <= registers[rs1];
            read_data2 <= registers[rs2];
        end
    end
    
    always @(negedge clk) begin //write register
        if(write_data == 1'b1 && rd != 5'b0000) begin
            registers[rd] <= reg_write;
        end
    end
endmodule
