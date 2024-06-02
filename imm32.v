`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 15:00:40
// Design Name: 
// Module Name: lab8_p2
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


module imm32(
in,imm,signextend
    );
    input  [31:0]in;
    input signextend;
    output reg [31:0] imm;
    wire [6:0] sign;
    assign sign=in[6:0];
        
        always @(*) begin
        //add unsined extention
           case (sign)
               7'b1101111: imm=$signed({in[31],in[19:12],in[20],in[30:21],1'b0});//UJ
               7'b1100011:imm=$signed({in[31],in[7],in[30:25],in[11:8],1'b0});//SB
               7'b0100011: imm=$signed({in[31:25],in[11:7]});//S
               7'b0010011: imm=$signed(in[31:20]);//I_caculate
               7'b0110111: imm=$signed(in[31:12]);//U_lui  
               7'b0010111: imm=$signed(in[31:12]);//U_auipc
               7'b0000011: imm=$signed(in[31:20]);//I_load 
               default: imm=0;
            endcase
         end    
endmodule
