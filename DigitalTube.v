
`timescale 1ns / 1ps


module DigitalTube(
    input clk,
    input[31:0] show_data, 
    output[7:0] seg,
    output[7:0] seg1,
    output[7:0] an 
);
    reg[18:0] divclk_cnt = 0;
    reg divclk = 0;
    reg[7:0] seg=0;
    reg[7:0] seg1=0;
    reg[7:0] an=8'b00000001;
    reg[3:0] disp_dat=0;
    reg[2:0] disp_bit=0;
    parameter maxcnt = 50000;
    always@(posedge clk)
    begin
        if(divclk_cnt==maxcnt)
        begin
            divclk=~divclk;
            divclk_cnt=0;
        end
        else
        begin
            divclk_cnt=divclk_cnt+1'b1;
        end
    end
    always@(posedge divclk) begin
        if(disp_bit >= 4)
            disp_bit=0;
         else
            disp_bit=disp_bit+1'b1;
         case (disp_bit)
            3'b000 :
            begin
                disp_dat=show_data[3:0];
                an=8'b00000001;
            end
            3'b001 :
            begin
                disp_dat=show_data[7:4];
                an=8'b00000010;
            end
            3'b010 :
            begin
                disp_dat=show_data[11:8];
                an=8'b00000100;
            end
            3'b011 :
            begin
                disp_dat=show_data[15:12];
                an=8'b00001000;
            end
            3'b100 :
            begin
                disp_dat=show_data[19:16];
                an=8'b00010000;
            end
            3'b101 :
            begin
                disp_dat=show_data[19:16];
                an=8'b00010000;
            end
            3'b110:
            begin
                disp_dat=show_data[19:16];
                an=8'b00010000;
            end
            3'b111:
            begin
                disp_dat=show_data[19:16];
                an=8'b00010000;
             end
            default:
            begin
                disp_dat=0;
                an=8'b00000000;
            end
        endcase
    end
    always@(disp_dat)
    begin
        if(an > 8'b00001000) begin
            case (disp_dat)
            //0-F
            4'h0 : seg = 8'hfc;
            4'h1 : seg = 8'h60;
            4'h2 : seg = 8'hda;
            4'h3 : seg = 8'hf2;
            4'h4 : seg = 8'h66;
            4'h5 : seg = 8'hb6;
            4'h6 : seg = 8'hbe;
            4'h7 : seg = 8'he0;
            4'h8 : seg = 8'hfe;
            4'h9 : seg = 8'hf6;
            4'ha : seg = 8'hee;
            4'hb : seg = 8'h3e;
            4'hc : seg = 8'h9c;
            4'hd : seg = 8'h7a;
            4'he : seg = 8'h9e;
            4'hf : seg = 8'h8e;
            endcase
        end
        else begin
            case (disp_dat)
            //0-F
            4'h0 : seg1 = 8'hfc;
            4'h1 : seg1 = 8'h60;
            4'h2 : seg1 = 8'hda;
            4'h3 : seg1 = 8'hf2;
            4'h4 : seg1 = 8'h66;
            4'h5 : seg1 = 8'hb6;
            4'h6 : seg1 = 8'hbe;
            4'h7 : seg1 = 8'he0;
            4'h8 : seg1 = 8'hfe;
            4'h9 : seg1 = 8'hf6;
            4'ha : seg1 = 8'hee;
            4'hb : seg1 = 8'h3e;
            4'hc : seg1 = 8'h9c;
            4'hd : seg1 = 8'h7a;
            4'he : seg1 = 8'h9e;
            4'hf : seg1 = 8'h8e;
            endcase
        end
    end
endmodule

/*
## clk
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

##smg
set_property PACKAGE_PIN G2 [get_ports an[7]]
set_property IOSTANDARD LVCMOS33 [get_ports an[7]]
set_property PACKAGE_PIN C2 [get_ports an[6]]
set_property IOSTANDARD LVCMOS33 [get_ports an[6]]
set_property PACKAGE_PIN C1 [get_ports an[5]]
set_property IOSTANDARD LVCMOS33 [get_ports an[5]]
set_property PACKAGE_PIN H1 [get_ports an[4]]
set_property IOSTANDARD LVCMOS33 [get_ports an[4]]
set_property PACKAGE_PIN G1 [get_ports an[3]]
set_property IOSTANDARD LVCMOS33 [get_ports an[3]]
set_property PACKAGE_PIN F1 [get_ports an[2]]
set_property IOSTANDARD LVCMOS33 [get_ports an[2]]
set_property PACKAGE_PIN E1 [get_ports an[1]]
set_property IOSTANDARD LVCMOS33 [get_ports an[1]]
set_property PACKAGE_PIN G6 [get_ports an[0]]
set_property IOSTANDARD LVCMOS33 [get_ports an[0]]

set_property PACKAGE_PIN B4 [get_ports {seg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[7]}]
set_property PACKAGE_PIN A4 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property PACKAGE_PIN A3 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN B1 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN A1 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN B3 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN B2 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN D5 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

set_property PACKAGE_PIN D4 [get_ports {seg1[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg1[7]}]
set_property PACKAGE_PIN E3 [get_ports {seg1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg1[6]}]
set_property PACKAGE_PIN D3 [get_ports {seg1[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg1[5]}]
set_property PACKAGE_PIN F4 [get_ports {seg1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg1[4]}]
set_property PACKAGE_PIN F3 [get_ports {seg1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg1[3]}]
set_property PACKAGE_PIN E2 [get_ports {seg1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg1[2]}]
set_property PACKAGE_PIN D2 [get_ports {seg1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg1[1]}]
set_property PACKAGE_PIN H2 [get_ports {seg1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg1[0]}]

*/
