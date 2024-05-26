`timescale 1ns/1ps
module sim_2;
    reg clk;
    reg rst;
    reg [7:0] switches;
    reg button;
    main umain(.clk(clk), .rst(rst), .Switches(switches), .Button(button));

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        switches = 8'b0001_0101;
        button = 1'b0;
        #17 rst = ~rst;
    end

    always begin
        repeat(500) #5 clk = ~clk;
        #10 $finish;
    end

    always begin
        #150 button = 1'b1;
        #150 button = 1'b0;
        #150 button = 1'b1;
        #150 button = 1'b0;
    end

    initial begin
        #400 switches = 8'b0110_1101;
    end

endmodule