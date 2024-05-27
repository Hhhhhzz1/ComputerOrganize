`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 19:13:11
// Design Name: 
// Module Name: ALU
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


module ALU(
ReadData1, ReadData2,imm32,zero,ALUResult,ALUOp,ALUSrc,funct3,funct7
    );
    input[31:0]ReadData1, ReadData2, imm32;
    input ALUSrc;
    input[1:0]ALUOp;
    input[2:0]funct3;
    input[6:0]funct7;
    output reg [31:0]ALUResult;
    output reg zero;
    
    wire[31:0] realData;
    assign realData = (ALUSrc == 1'b1)? imm32 : ReadData2;
    always @(*) begin
    case(ALUOp)
       2'b00:ALUResult=(realData+ReadData1);
       2'b01:
       begin  //unsigned or signed
       case(funct3)
       3'b110,3'b111:ALUResult=(ReadData1-realData);
       default:
       begin 
       
       ALUResult=($signed(ReadData1)-$signed(realData)); 
       end
       endcase
       end
       2'b10:
       begin
           case(funct3)
           3'b000,3'b010:ALUResult=(realData+ReadData1);//add or addi
           3'b100:ALUResult=(ReadData1^realData);//xor
           3'b110:ALUResult=(ReadData1|realData);//or
           3'b111:ALUResult=(ReadData1&realData);//and
           3'b001:ALUResult=(ReadData1<<realData);//sll or slli
           3'b101:begin
           case(funct7)
           7'd0:ALUResult=(ReadData1>>realData);
           7'd4:ALUResult=($signed(ReadData1)>>realData);        
           endcase
           end//srl or srli
           endcase
       end
       2'b11:ALUResult=(realData << 12);//lui
    endcase
    end
    always @(*) begin
    if(ALUOp==2'b01) begin
    case(funct3)
    3'b100,3'b110:zero =($signed(ALUResult)<0)?1:0;
    3'b101,3'b111:zero =($signed(ALUResult)>=0)?1:0;
    3'b001:zero =($signed(ALUResult)!=0)?1:0;
    3'b000: zero =($signed(ALUResult)==0)?1:0;
    default:zero=0;
    endcase
    end
    else
    zero=0;
    end
endmodule
