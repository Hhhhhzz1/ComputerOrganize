`timescale 1ns / 1ps

module Ifetch(  
  
    input     clk,
    input     rst,
    
    input[31:0] instruction,
    input[31:0] dest_addr,  //  destination address from ALU
    input[31:0] jalr_addr,  //  address from `jalr` instruction
    
    input     beq,
    input     bne,
    input     equal,
    input     jmp,
    input     jal,
    input     jr,


    output reg [31:0] adjacent_PC,  // store the adjacent next instruction address of the current one 
    output reg [31:0] PC            // next PC
    
);

    wire [31:0] curr_PC;
    reg [31:0] dest_PC;
    assign curr_PC = PC;

    always @(*) begin
        if (jr)
            dest_PC = dest_addr;
        else if ((beq && equal) || (bne && !equal)) 
            dest_PC = dest_addr;
        else if (jmp || jal)
            dest_PC = {PC[31:28], instruction[25:0], 2'b00};
        else 
            dest_PC = PC + 4;
    end


    always @(negedge clk or posedge rst) begin
        if (rst)
            PC <= 0;
        else
            PC <= dest_PC;
        if (jal)
            adjacent_PC <= curr_PC + 4;
    end


endmodule
