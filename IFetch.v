`timescale 1ns / 1ps

module IFetch(  
  
    input     clk,
    input     rst,
    
    input[31:0] instruction,
    input[31:0] imm,  //  destination address from ALU
    input[31:0] rs,  //  address from `jalr` instruction
    
    input     beq,
    input     equal,
    input     jal,
    input     jr,


    output reg [31:0] adjacent_PC,  // store the adjacent next instruction address of the current one 
    output reg [31:0] PC          // next PC
    
);
    

    reg [31:0] dest_PC;
   
    always @(negedge clk or posedge rst) begin
        if(rst==1'b1)
        PC=0;
        else if (jr) 
            PC = rs; 
        else if ((beq && equal)) 
            PC = imm+PC;
        else if (jal) begin
            adjacent_PC=PC+4;
            PC = imm+PC;
        end    
        else 
            PC = PC + 4;
    end


//    always @(negedge clk) begin
//        if (rst)
//            PC <= 0;
//        else
//            PC <= dest_PC;
//        if (jal)
//            adjacent_PC <= curr_PC + 4;
//    end


endmodule
