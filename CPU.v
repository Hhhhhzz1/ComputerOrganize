`timescale 1ns / 1ps

module CPU(
    clk, rst, ConfirmCtrl, test_index, led_data
    );
    input clk, rst;
    input ConfirmCtrl;
    input [2:0] test_index;
    output [15:0] led_data;
    
    
    wire [31:0] dest_addr;
    wire [31:0] jalr_addr, read_data1, read_data2, r_wdata; // ????
    wire [31:0] PC;
    wire [31:0] instruction;
    wire [31:0] link_addr;
    wire jmp, jal, jr, b_beq, b_bne; 
    wire [31:0] immNum, numRe1, numRe2;
    
    wire [31:0] ALU_result;
    wire ALUSrc, zero;
    wire MemRead, MemWrite, IORead, IOWrite, RegWrite;
    wire LEDCtrl;
    wire [1:0] ALUOp;
    wire [31:0] write_data, addr_out, m_rdata;
    
    wire [7:0] io_rdata;
    wire I_format, Sftmd, RegDST, MemorIOtoReg, SwitchCtrl; // ????
    
    IFetch ifetch (.clk(clk), .rst(rst), .instruction(instruction),
                   .dest_addr(dest_addr), .jalr_addr(jalr_addr), .read_data(read_data1),
                   .branch_beq(b_beq),
                   .branch_bne(b_bne), .equal(zero), .jmp(jmp) ,.jal(jal) ,.jr(jr),
                   .adjacent_PC(link_addr), .PC(PC));
    
    decoder decoder (.instruction(instruction), .immNum(immNum), 
                     .numRe1(numRe1), .numRe2(numRe2), .clk(clk));
                     
    ALU alu (.ReadData1(read_data1), .ReadData2(read_data2),.imm32(immNum),
             .zero(zero), .ALUResult(ALU_result), .ALUOp(ALUOp), .ALUSrc(ALUSrc),
             .funct3(instruction[14:12]), .funct7
(instruction[31:25]));
    
    Led led (.rst(rst), .LEDCtrl(LEDCtrl), 
             .write_data(write_data), .led_data(led_data)
);
    
    control32 ctrl (.Instruction(instruction), .Jr(jr), .Branch(b_beq), .Jal(jal),
                    .Alu_resultHigh(ALU_result[31:10]), 
                    .RegDST(RegDST), .MemorIOtoReg(MemorIOtoReg), .RegWrite(RegWrite), 
                    .MemRead(MemRead), .MemWrite(MemWrite),
                    .IORead(IORead), .IOWrite(IOWrite),
                    .ALUSrc(ALUSrc), .ALUOp(ALUOp), .Sftmd(Sftmd), .I_format(I_format));
   
    MemOrIO MemOrIO (.mRead(MemRead), .mWrite(MemWrite), .ioRead(IORead), .ioWrite(IOWrite),
                     .addr_in(ALU_result), .addr_out(addr_out), .m_rdata(m_rdata), .io_rdata(io_rdata), 
                     .r_wdata(r_wdata), .r_rdata(read_data2), .write_data(write_data), 
                     .LEDCtrl(LEDCtrl), .SwitchCtrl(SwitchCtrl), .ConfirmCtrl(ConfirmCtrl), .test_index(test_index));
    
    wire [13:0]addr;//??
    progrom urom(clk, addr, instruction);
    
endmodule
