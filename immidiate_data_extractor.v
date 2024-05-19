`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/19 23:32:02
// Design Name: 
// Module Name: immidiate_data_extractor
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


module immidiate_data_extractor(
    instruction, imm_data
    );
    input [31:0] instruction;
    output reg [31:0] imm_data;
    
    initial begin //initial set imm_data be 0
        imm_data = 32'h0000;
    end
    
    always @* begin
        case(instruction[6:5])
            2'b00: imm_data[11:0] = instruction[31:20];
            2'b01: imm_data[11:0] = {instruction[31:25], instruction[11:7]};
            2'b11: imm_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
            
            endcase 
            imm_data = {{20{imm_data[11]}},{imm_data[11:0]}}; //signed extension
        end
    
endmodule
