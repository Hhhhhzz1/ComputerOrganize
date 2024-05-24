module ALU(
    ReadData1, ReadData2, imm32, zero, ALUResult, ALUOp, ALUSrc, funct3, funct7
);
    input [31:0] ReadData1, ReadData2, imm32;
    input ALUSrc;
    input [1:0] ALUOp;
    input [2:0] funct3;
    input [6:0] funct7;
    output reg [31:0] ALUResult;
    output reg zero;
    
    wire [31:0] realData;
    assign realData = (ALUSrc == 1'b1) ? imm32 : ReadData2;
    
    always @(*) begin
        case(ALUOp)
            2'b00: ALUResult = (realData + ReadData1);
            2'b01: ALUResult = (ReadData1 - realData);
            2'b10: begin
                case ({funct7, funct3})
                    10'b0000000000: ALUResult = (realData + ReadData1); // ADD
                    10'b0100000000: ALUResult = (ReadData1 - realData); // SUB
                    10'b0000000111: ALUResult = (ReadData1 & realData); // AND
                    10'b0000000110: ALUResult = (ReadData1 | realData); // OR
                    10'b0000000100: ALUResult = (ReadData1 ^ realData); // XOR
                    10'b0000000001: ALUResult = (ReadData1 << realData); // SLL
                    10'b0000000101: ALUResult = (ReadData1 >> realData); // SRL
                    10'b0100000101: ALUResult = (ReadData1 >>> realData); // SRA
                endcase
            end
        endcase
    end
    
    always @(*) begin
        if(ALUOp == 2'b01) begin
            case(funct3)
                3'b100: zero = (ALUResult <= 0) ? 1 : 0;
                3'b101: zero = (ALUResult >= 0) ? 1 : 0;
                3'b001: zero = (ALUResult == 1) ? 1 : 0;
                3'b000: zero = (ALUResult == 0) ? 1 : 0;
                default: zero = 0;
            endcase
        end
    end
endmodule
