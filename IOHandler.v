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
    input [7:0] read_digit, [3:0] bit_width, button, tube, 
    input need_read, //is need to read
    output reg [31:0] write_digit, is_reading //1 means need to wait, 0 means need to continue
    );
    reg [31:0] input_buffer;
    reg [31:0] cnt;
    
    initial begin
        cnt = 32'h0000;
    end
    always @* begin
        if(need_read && cnt < bit_width) begin
            is_reading = 1'b1;
            if(button == 1'b1) begin //maybe need to debounce
                input_buffer[cnt*8 +:8] = read_digit;
                cnt = cnt + 32'h0001;
            end
        end
        else if(cnt == bit_width) begin
            is_reading = 1'b0;
            write_digit = input_buffer;
        end
        else if(!need_read) begin
            cnt = 32'h0000;
        end
    end
endmodule
