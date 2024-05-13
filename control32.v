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
 Alu_resultHigh, 
RegDST, MemorIOtoReg, RegWrite, 
MemRead, MemWrite, 
IORead, IOWrite,
 ALUSrc,ALUOp,Sftmd,I_format);
 
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
    
    
    input[21:0] Alu_resultHigh;// From the execution unit Alu_Result[31..10]
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
    assign ALUOp={(opcode==7'b0110011),Branch};
    assign RegDST=(opcode==7'b0110011||I_format);//R type I type
    assign ALUSrc=(opcode==7'b0110011)?0:1; // R=0 ELSE =1
    
    wire lw=(opcode==7'b0000011)?1:0;
    wire sw=(opcode==7'b0100011)?1:0;
    
    
    assign RegWrite = (opcode==7'b0110011||I_format);//R type I type      
    assign IORead  = ((lw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0; 
    assign IOWrite=((sw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0; 
    assign MemWrite = ((sw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;  
    assign MemRead = ((lw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF))? 1'b1:1'b0;     
    assign MemorIOtoReg = IORead || MemRead;   

endmodule
