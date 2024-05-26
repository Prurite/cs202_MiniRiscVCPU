`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 01:13:09
// Design Name: 
// Module Name: IOHandler
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


module IOHandler(
    input [7:0] read_digit, [3:0] bit_width, button,
    input need_read, //is need to read
    output reg [31:0] write_digit, reg stall //1 means need to wait, 0 means need to continue
    );
    reg [31:0] input_buffer;
    reg [31:0] cnt;
    
    initial begin 
        cnt = 32'h0000;
    end
    always @* begin
        if(need_read == 1'b1 && cnt < bit_width) begin
            stall = 1'b1;
            if(button == 1'b1) begin
                input_buffer[cnt*8 +: 8] = read_digit;
                cnt = cnt + 1;
            end 
            if(cnt == bit_width) begin
                write_digit = input_buffer;
            end
        end
        else if (cnt == bit_width) begin
            stall = 1'b1;
            if(button == 1'b1) begin
                stall = 1'b0;
                cnt = 32'h0000;
                input_buffer = cnt;
            end
        end
    end
endmodule
