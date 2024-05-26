`timescale 1ns/1ps

module SegDisplayOutput (
    input clk, rst,
    input [31:0] x,
    output reg [7:0] seg0, seg1,
	output reg [3:0] seg_sel0, seg_sel1
);
    // Local parameters for 7-seg display
    reg [3:0] i; // 1 to 4; 0 off

    always @(posedge clk) begin
        // 1st group
        case(x[(i-1)*4 +: 4])
            4'h0: seg0 <= 8'b00111111; 4'h1: seg0 <= 8'b00000110; 4'h2: seg0 <= 8'b01011011;
            4'h3: seg0 <= 8'b01001111; 4'h4: seg0 <= 8'b01100110; 4'h5: seg0 <= 8'b01101101;
            4'h6: seg0 <= 8'b01111101; 4'h7: seg0 <= 8'b00000111; 4'h8: seg0 <= 8'b01111111;
            4'h9: seg0 <= 8'b01101111;
            4'ha: seg0 <= 8'b01110111; 4'hb: seg0 <= 8'b01111100; 4'hc: seg0 <= 8'b00111001;
            4'hd: seg0 <= 8'b01011110; 4'he: seg0 <= 8'b01111001; 4'hf: seg0 <= 8'b01110001;
            default: seg0 <= 8'b10000000;
        endcase

        // 2nd group
        case(x[(4+i-1)*4 +: 4])
            4'h0: seg1 <= 8'b00111111; 4'h1: seg1 <= 8'b00000110; 4'h2: seg1 <= 8'b01011011;
            4'h3: seg1 <= 8'b01001111; 4'h4: seg1 <= 8'b01100110; 4'h5: seg1 <= 8'b01101101;
            4'h6: seg1 <= 8'b01111101; 4'h7: seg1 <= 8'b00000111; 4'h8: seg1 <= 8'b01111111;
            4'h9: seg1 <= 8'b01101111;
            4'ha: seg1 <= 8'b01110111; 4'hb: seg1 <= 8'b01111100; 4'hc: seg1 <= 8'b00111001;
            4'hd: seg1 <= 8'b01011110; 4'he: seg1 <= 8'b01111001; 4'hf: seg1 <= 8'b01110001;
            default: seg1 <= 8'b10000000;
        endcase
    end

    always @(posedge clk)
        if (rst) begin
            i <= 4'd1;
            seg_sel0 <= 4'b0;
            seg_sel1 <= 4'b0;
        end else begin
            i <= i == 4'd4 ? 4'd1 : i + 4'd1;
            case(i)
                4'd1: seg_sel0 <= 4'b0001;
                4'd2: seg_sel0 <= 4'b0010;
                4'd3: seg_sel0 <= 4'b0100;
                4'd4: seg_sel0 <= 4'b1000;
                default: seg_sel0 <= 4'b0000;
            endcase
            case(i)
                4'd1: seg_sel1 <= 4'b0001;
                4'd2: seg_sel1 <= 4'b0010;
                4'd3: seg_sel1 <= 4'b0100;
                4'd4: seg_sel1 <= 4'b1000;
                default: seg_sel1 <= 4'b0000;
            endcase
        end
endmodule