`timescale 1ns / 1ps

module CPU(
    clk, rst, ConfirmCtrl, test_index, led_data,start_pg, rx, tx,io_rdata
    );
    input clk, rst;
    input ConfirmCtrl;
    input [7:0] io_rdata;
    input [2:0] test_index;
    output [15:0] led_data;
    input start_pg;
    input rx;
    output tx;    
    
    wire [31:0] dest_addr;
    wire [31:0] jalr_addr, read_data1, read_data2, r_wdata; // ????
    wire [31:0] PC;
    wire [31:0] instruction;
    wire [31:0] link_addr;
    wire jmp, jal, jr, b_beq, b_bne; 
    wire [31:0] immNum;
    
    wire [31:0] ALU_result;
    wire ALUSrc, zero;
    wire MemRead, MemWrite, IORead, IOWrite, RegWrite;
    wire LEDCtrl;
    wire [1:0] ALUOp;
    wire [31:0] write_data, addr_out, m_rdata;
    
    
    wire I_format, Sftmd, RegDST, MemorIOtoReg, SwitchCtrl; // ????
    
    wire cpu_clk,upg_clk;
    CPUclk cpuClk(.clk_in1(clk),.clk_out1(cpu_clk),.clk_out2(upg_clk));
    

        wire upg_clk_o; 
        wire upg_wen_o; 
        wire upg_done_o; //Uart rx data have done 
    //data address to program_rom/dmemory32 
        wire [14:0] upg_adr_o; 
    //data to program_rom or dmemory32 
        wire [31:0] upg_dat_o;
    
         
        reg upg_rst; 
        always @ (posedge clk) begin 
            if (start_pg) upg_rst = 0; 
            if (rst) upg_rst = 1; 
        end 
   //rst_2 when urt change than reset anything
        wire rst_2;
        assign rst_2 = rst | !upg_rst;
        uart Uart(.upg_clk_i(upg_clk), .upg_rst_i(upg_rst), .upg_rx_i(rx), .upg_tx_o(tx),
        .upg_clk_o(upg_clk_o), .upg_wen_o(upg_wen_o), .upg_adr_o(upg_adr_o), .upg_dat_o(upg_dat_o), .upg_done_o(upg_done_o));
    
    programrom program(.rom_clk_i(cpu_clk),.rom_adr_i(PC[15:2]),.Instruction_o(instruction),
        .upg_rst_i(upg_rst),.upg_clk_i(upg_clk_o),.upg_wen_i(upg_wen_o&!upg_adr_o[14]),
        .upg_adr_i(upg_adr_o[13:0]),.upg_dat_i(upg_dat_o),.upg_done_i(upg_done_o));
        
       dmemory32 memory(.ram_clk_i(cpu_clk),.ram_wen_i(MemWrite),.ram_adr_i(addr_out[15:2]),
            .ram_dat_i(write_data),.ram_dat_o(m_rdata),.upg_rst_i(upg_rst),.upg_clk_i(upg_clk_o),
            .upg_wen_i(upg_wen_o&upg_adr_o[14]),.upg_adr_i(upg_adr_o[13:0]),.upg_dat_i(upg_dat_o),.upg_done_i(upg_done_o));
        
    
    IFetch ifetch (.clk(cpu_clk), .rst(rst_2), .instruction(instruction),
                   .dest_addr(dest_addr), .jalr_addr(jalr_addr), .read_data(read_data1),
                   .branch_beq(b_beq),
                   .branch_bne(b_bne), .equal(zero), .jmp(jmp) ,.jal(jal) ,.jr(jr),
                   .adjacent_PC(link_addr), .PC(PC));
    
    decoder decoder (.instruction(instruction), .immNum(immNum), .reset(rst_2),.r_wdata(r_wdata),
                     .numRe1(read_data1), .numRe2(read_data2), .clk(cpu_clk),.ALUResult(ALU_result)
                     ,.regWrite(RegWrite),.MemtoReg(MemorIOtoReg));
                     
    ALU alu (.ReadData1(read_data1), .ReadData2(read_data2),.imm32(immNum),
             .zero(zero), .ALUResult(ALU_result), .ALUOp(ALUOp), .ALUSrc(ALUSrc),
             .funct3(instruction[14:12]), .funct7
(instruction[31:25]));
    
    Led led (.rst(rst_2), .LEDCtrl(LEDCtrl), 
             .write_data(write_data), .led_data(led_data)
);
    
    control32 ctrl (.Instruction(instruction), .Jr(jr), .Branch(b_beq), .Jal(jal),
                    . rega7(rega7),
                    .RegDST(RegDST), .MemorIOtoReg(MemorIOtoReg), .RegWrite(RegWrite), 
                    .MemRead(MemRead), .MemWrite(MemWrite),
                    .IORead(IORead), .IOWrite(IOWrite),
                    .ALUSrc(ALUSrc), .ALUOp(ALUOp), .Sftmd(Sftmd), .I_format(I_format));
   
    MemOrIO MemOrIO (.mRead(MemRead), .mWrite(MemWrite), .ioRead(IORead), .ioWrite(IOWrite),
                     .addr_in(ALU_result), .addr_out(addr_out), .m_rdata(m_rdata), .io_rdata(io_rdata), 
                     .r_wdata(r_wdata), .r_rdata(read_data2), .write_data(write_data), 
                     .LEDCtrl(LEDCtrl),  .ConfirmCtrl(ConfirmCtrl), .test_index(test_index), .rega7(rega7),.shuma(shuma),.signextend(signextend));
    


    
endmodule
