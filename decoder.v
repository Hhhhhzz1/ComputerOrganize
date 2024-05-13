`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/15 15:00:10
// Design Name: 
// Module Name: decoder_p2
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


module decoder(
instruction,immNum,numRe1,numRe2,clk
    );
    reg[31:0] register[0:31];
    reg regWrite=1'b0;
    parameter data=2;
    input[31:0]instruction;
    input clk;
    output [31:0]immNum,numRe1;
    output [31:0]  numRe2;
    imm32 imm(.in(instruction),.imm(immNum));
    assign numRe1=register[instruction[19:15]];
    assign numRe2=register[instruction[24:120]];
    always @(*) begin
    case(instruction[6:0])
         7'b0000011:regWrite=1'b1;//i-type
         7'b0110011:regWrite=1'b1;//r-type
         7'b0110111:regWrite=1'b1;//u-type
         7'b1101111:regWrite=1'b1;//uj-type
         default: regWrite=1'b0;
    endcase
    end
    always@(clk)begin
    if(regWrite==1'b1&&instruction[11:7]!=7'b0000000) begin
    register[instruction[11:7]] <= data;
    end
    end
endmodule
