`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 10:37:57
// Design Name: 
// Module Name: control32
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


module  control32(Instruction,Jr,Branch,Jal,
RegDST, MemorIOtoReg, RegWrite, 
MemRead, MemWrite, 
IORead, IOWrite,
//AluResult,
 ALUSrc,ALUOp,Sftmd,I_format
 ,rega7
 );
 
    input[31:0]  Instruction;               
    output       Jr;              // 1 indicates jr instruction TO ALU IF
    output       Branch;        // 1 indicates B type TO IF
    output       RegDST;          // 1 indicates dst is rd
    output       ALUSrc;          // 1 indicates ALU 2nd input from imm,0 indicates  from reg
    output       RegWrite;         // 1 indicates need writing reg
    output       MemWrite;       // 1 indicates need writing memory
   // output       Jmp;            // 1 indicates J type TO ALU  IF
    output       Jal;            // 1 indicates jal instruction  TO ALU  IF
    output       I_format;      // 1 indicates I type  TO ALU 
    output       Sftmd;         // 1 indicates shift instruction TO ALU
    output[1:0]  ALUOp;         // to ALU
    
    input[31:0] 
//    AluResult;
    rega7;//read a7 from register
    //input[21:0] Alu_resultHigh;// From the execution unit Alu_Result[31..10]
    output MemorIOtoReg;  // 1 indicates that data needs to be read from memory or I/O to the register
    output MemRead;             // 1 indicates that the instruction needs to read from the memory
    output IORead;              // 1 indicates I/O read 
    output IOWrite;             // 1 indicates I/O write
    
    wire [6:0] opcode;
    assign opcode=Instruction[6:0];
    
    assign Jr=(opcode==7'b1100111)?1:0;
    assign Jal=(opcode==7'b1101111)?1:0;
    assign I_format=(opcode==7'b0010011||opcode==7'b0000011)?1:0;
    assign Sftmd=(((opcode==7'b0010011)||(opcode==7'b0110011))&&((Instruction[14:12]==3'h3)||(Instruction[14:12]==3'h2)||(Instruction[14:12]==3'h5)||(Instruction[14:12]==3'h1)))?1:0;
    assign Branch=(opcode==7'b1100011)?1:0;// beq bnq blt bge
    assign ALUOp=(opcode==7'b0110111)?2'b11:{(opcode==7'b0110011||opcode==7'b0010011),Branch};  //to add jal and jr
    assign RegDST=(opcode==7'b0110011||I_format)?1'b1:1'b0;//R type I type
    assign ALUSrc=(opcode==7'b0110011||Branch)?0:1; // R=0 ELSE =1
    
    wire lw;
    assign lw=(opcode==7'b0000011)?1:0;
    wire sw;
    assign sw=(opcode==7'b0100011)?1:0;
    
    
    assign RegWrite = (opcode==7'b0110011||I_format||MemorIOtoReg||opcode==7'b1101111||opcode==7'b0110111)
    ?1'b1:1'b0;//R type I type      
    assign IORead  = 
    ((rega7>=0&&rega7<=3)&&Instruction==32'h00000073) 
//((lw == 1) && (AluResult[31:12] == 20'hFFFFF))
    ? 1'b1:1'b0; 
    assign IOWrite=
    ((rega7>=4&&rega7<=5)&&Instruction==32'h00000073 )
//((sw == 1) && (AluResult[31:12] == 20'hFFFFF))
    ? 1'b1:1'b0; 
    assign MemWrite = 
    ((sw==1))
//((sw == 1) && (AluResult[31:12] != 20'hFFFFF))
     ? 1'b1:1'b0;  
    assign MemRead = 
    ((lw==1))
//((lw == 1) && (AluResult[31:12] != 20'hFFFFF))
    ? 1'b1:1'b0;     
    assign MemorIOtoReg = (IORead || MemRead)? 1'b1:1'b0;   

endmodule
