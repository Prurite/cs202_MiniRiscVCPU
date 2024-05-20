`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/14 14:53:24
// Design Name: 
// Module Name: PC
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


module program_counter(
    pc_in, pc_out, clk, reset
    );
    input [31:0]pc_in;
    input clk;
    input reset;
    output reg [31:0]pc_out;
    
    always @(posedge clk, posedge reset) begin
        if(reset == 1'b1) begin
            pc_out <= 32'h0000;
        end
        else begin
            pc_out <= pc_in;
        end
    end
endmodule
