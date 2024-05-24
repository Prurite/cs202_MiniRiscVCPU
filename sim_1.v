`timescale 1ns / 1ps

module sim_1;


  // Inputs
  reg clk;
  reg rst;
  // Outputs


  // Instantiate the Unit Under Test (UUT)
  main umain (
    .clk(clk),
    .rst(rst)
  );

  // Initialize inputs
  initial begin
    clk = 1'b0;
    rst = 1'b0;
    #17 rst = ~rst;
  end

  // Stimulus
  always begin
    repeat(500) #5 clk = ~clk;
    #10 $finish;

  end




  // Monitor

endmodule
