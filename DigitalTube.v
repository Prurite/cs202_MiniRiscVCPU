`timescale 1ns / 1ps

module DigitalTube( //tube controller
    input clk, rst, //clock and reset, 100MHz
    input [31:0] show_data, //data to display
    output reg [7:0] seg, seg1, an //7-seg display, positive, negative, select signal
);
    reg[18:0] divclk_cnt = 0;
    reg divclk = 0;
    reg[3:0] disp_dat = 0;
    reg[2:0] disp_bit = 0;

    parameter maxcnt = 50000; //100MHz -> 2KHz
    
    always@(posedge clk)  //internal clock divider, 100MHz -> 2KHz
        if(divclk_cnt == maxcnt) begin
            divclk <= ~divclk;
            divclk_cnt <= 0;
        end else
            divclk_cnt <= divclk_cnt + 1'b1;
    

    always@(posedge divclk) begin //set display data on each bit, use 16bits per digit, 7<-0 corresponding to right<-left
        if(!rst || disp_bit >= 7)
            disp_bit <= 0;
        else
            disp_bit <= disp_bit+1'b1;
        case (disp_bit) //can't be modified to bit shift and show_data[disp_bit*4+3:disp_bit*4], what a strange bug
            3'b000 :
            begin
                disp_dat <= show_data[3:0];
                an <= 8'b00000001;
            end
            3'b001 :
            begin
                disp_dat <= show_data[7:4];
                an <= 8'b00000010;
            end
            3'b010 :
            begin
                disp_dat <= show_data[11:8];
                an <= 8'b00000100;
            end
            3'b011 :
            begin
                disp_dat <= show_data[15:12];
                an <= 8'b00001000;
            end
            3'b100 :
            begin
                disp_dat <= show_data[19:16];
                an <= 8'b00010000;
            end
            3'b101 :
            begin
                disp_dat <= show_data[23:20];
                an <= 8'b00100000;
            end
            3'b110:
            begin
                disp_dat <= show_data[27:24];
                an <= 8'b01000000;
            end
            3'b111:
            begin
                disp_dat <= show_data[31:28];
                an <= 8'b10000000;
             end
            default:
            begin
                disp_dat <= 0;
                an <= 8'b00000000;
            end
        endcase
    end
    always@(disp_dat) begin //set 7-seg display data, duplicate work
        if(an > 8'b00001000) begin
            case (disp_dat)
                //0-F
                4'h0 : seg <= 8'hfc;
                4'h1 : seg <= 8'h60;
                4'h2 : seg <= 8'hda;
                4'h3 : seg <= 8'hf2;
                4'h4 : seg <= 8'h66;
                4'h5 : seg <= 8'hb6;
                4'h6 : seg <= 8'hbe;
                4'h7 : seg <= 8'he0;
                4'h8 : seg <= 8'hfe;
                4'h9 : seg <= 8'hf6;
                4'ha : seg <= 8'hee;
                4'hb : seg <= 8'h3e;
                4'hc : seg <= 8'h9c;
                4'hd : seg <= 8'h7a;
                4'he : seg <= 8'h9e;
                4'hf : seg <= 8'h8e;
            endcase
        end else begin
            case (disp_dat)
                //0-F
                4'h0 : seg1 <= 8'hfc;
                4'h1 : seg1 <= 8'h60;
                4'h2 : seg1 <= 8'hda;
                4'h3 : seg1 <= 8'hf2;
                4'h4 : seg1 <= 8'h66;
                4'h5 : seg1 <= 8'hb6;
                4'h6 : seg1 <= 8'hbe;
                4'h7 : seg1 <= 8'he0;
                4'h8 : seg1 <= 8'hfe;
                4'h9 : seg1 <= 8'hf6;
                4'ha : seg1 <= 8'hee;
                4'hb : seg1 <= 8'h3e;
                4'hc : seg1 <= 8'h9c;
                4'hd : seg1 <= 8'h7a;
                4'he : seg1 <= 8'h9e;
                4'hf : seg1 <= 8'h8e;
            endcase
        end
    end
endmodule