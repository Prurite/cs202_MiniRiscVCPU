`timescale 1ns / 1ps

module Hazard(
    input clk, rst,
    input [31:0] inst,
    output reg stall,
    output reg forwarding_EX_EX1,
    output reg forwarding_EX_EX2,
    output reg forwarding_MEM_EX1,
    output reg forwarding_MEM_EX2
);

// define parameter
localparam JAL   = 7'b1101111;
localparam JALR  = 7'b1100111;
localparam LUI   = 7'b0110111;
localparam AUIPC = 7'b0010111;
localparam ECALL = 7'b1110011;
localparam LOAD  = 7'b0000011;
localparam RTYPE = 7'b0110011;
localparam ILOAD = 7'b0010011; // for lw
localparam ITYPE = 7'b00x0011; 

reg [31:0] preInst1, preInst2;
wire [6:0] opcode = inst[6:0];
wire [6:0] preOpcode1 = preInst1[6:0];
wire [6:0] preOpcode2 = preInst2[6:0];

always @(negedge clk) begin
    if (~rst) begin
        preInst1 <= 32'b0;
        preInst2 <= 32'b0;
    end else begin
        preInst1 <= inst;
        preInst2 <= preInst1;
    end
end

always @(posedge clk) begin
    if (~rst) begin
        stall <= 1'b0;
        forwarding_EX_EX1 <= 1'b0;
        forwarding_MEM_EX1 <= 1'b0;
        forwarding_EX_EX2 <= 1'b0;
        forwarding_MEM_EX2 <= 1'b0;
    end else begin
        // initialization
        stall <= 1'b0;
        forwarding_EX_EX1 <= 1'b0;
        forwarding_MEM_EX1 <= 1'b0;
        forwarding_EX_EX2 <= 1'b0;
        forwarding_MEM_EX2 <= 1'b0;

        // if the present inst have src
        if (opcode != JAL && opcode != JALR && opcode != LUI && opcode != AUIPC && opcode != ECALL) begin
            // check for hazards
            check_hazards(preInst1, preOpcode1, 1);
            check_hazards(preInst2, preOpcode2, 2);
        end
    end
end


task check_hazards(input [31:0] preInst, input [6:0] preOpcode, input integer stage);
    begin
        if ((preOpcode == LOAD) || (preOpcode == RTYPE) || (preOpcode == ILOAD)) begin // preOpcode have dest register
            if (inst[19:15] == preInst[11:7]) begin // SRC1 have hazard
                assign_forwarding(stage, preOpcode == LOAD, 1);
            end
            if ((opcode != ITYPE) && (inst[24:20] == preInst[11:7])) begin // inst now have 2 src registers and the second one has hazard
                assign_forwarding(stage, preOpcode == LOAD, 2);
            end
        end
    end
endtask

// assign forwarding and stall
task assign_forwarding(input integer stage, input is_load, input integer src);
    begin
        if (src == 1) begin
            stall <= is_load && stage == 1;
            forwarding_MEM_EX1 <= is_load && stage == 1;
            forwarding_EX_EX1 <= !is_load && stage == 1;
        end else begin
            stall <= is_load && stage == 1;
            forwarding_MEM_EX2 <= is_load && stage == 1;
            forwarding_EX_EX2 <= !is_load && stage == 1;
        end
    end
endtask

endmodule