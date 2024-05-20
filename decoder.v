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
instruction,immNum,numRe1,numRe2,clk,r_wdata,ALUResult,MemtoReg,regWrite,reset,a7,signextend
    );
    reg[31:0] register[0:31];
    input regWrite,reset;
    wire [31:0]data;
    input[31:0]instruction;
    input clk,MemtoReg,signextend;
    input[31:0] r_wdata,ALUResult;
    output [31:0]immNum,numRe1;
    output [31:0]  numRe2,a7;
    integer i;
    initial  //change reg (zzz)->(0) 
    begin            
    for(i=0;i<=31;i=i+1) 
      begin
       register[i] <= i;
      end
    end
    
    imm32 imm(.in(instruction),.imm(immNum),.signextend(signextend));
    assign a7=register[17];
    assign data=(MemtoReg == 1'b1)? r_wdata : ALUResult;
    assign numRe1=register[instruction[19:15]];
    assign numRe2=(instruction == 32'h00000073&&(register[17]==4||register[17]==5))
    ?register[10]:register[instruction[24:20]];

    integer j;
    always@(posedge clk or posedge reset)begin
    if(reset) begin
    for(j=0;j<=31;j=j+1) begin
        register[j] <= 0;
    end
    end
    else if(regWrite==1'b1&&instruction[11:7]!=7'b0000000) begin
    register[instruction[11:7]] <= data;
    end
    end
    
     
endmodule
