`timescale 1ns / 1ps

module sim_1;
    reg clk, rst;

    main umain ( .clk_hw(clk), .rst(rst));

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        #17 rst = ~rst;
    end

    always begin
        repeat(500) #5 clk = ~clk;
        #10 $finish;
    end

endmodule