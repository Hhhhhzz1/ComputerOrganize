`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/16 17:11:23
// Design Name: 
// Module Name: light
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


module light(
rst,LEDCtrl,write_data,light_data,an,clk
    );
    input rst,clk;
    input LEDCtrl;
    input[31:0]write_data;
    output reg[7:0]an;
    output reg[6:0] light_data;
    
    reg[18:0] clkdiv=0;
    reg[3:0] display;// diaplay state
    always @(posedge clk ) begin
            
        clkdiv<=clkdiv+1;
    end
    
    wire [2:0] sign;
    assign sign=clkdiv[18:16];
    always @(*) begin
        case (sign)
          3'b000: an=8'b10000000;
          3'b001: an=8'b01000000;
          3'b010: an=8'b00100000;
          3'b011: an=8'b00010000;
          3'b100: an=8'b00001000;
          3'b101: an=8'b00000100;
          3'b110: an=8'b00000010;  
          3'b111: an=8'b00000001;      
        endcase
    end
    
    always @(*)begin
     case(sign)
       3'b000:display=write_data[31:28];
       3'b001:display=write_data[27:24];
       3'b010:display=write_data[23:20];
       3'b011:display=write_data[19:16];
       3'b100:display=write_data[15:12];
       3'b101:display=write_data[11:8];
       3'b110:display=write_data[7:4];
       3'b111:display=write_data[3:0];
     endcase 
    end    
     always @(*) begin
           case (display)
           4'h0:light_data=7'b1111110;//0  
           4'h1:light_data=7'b0110000;//1
           4'h1:light_data=7'b1101101;//2
           4'h2:light_data=7'b1111001;//3
           4'h3:light_data=7'b0110011;//4
           4'h4:light_data=7'b1011011;//5
           4'h5:light_data=7'b1011111;//6
           4'h6:light_data=7'b1110000;//7
           4'd10:light_data=7'b1110111;//A
           4'd11:light_data=7'b0011111;//b
           4'd12:light_data=7'b1001110;//c
           4'd13:light_data=7'b0111101;//d
           4'd14:light_data=7'b1101111;//e
           4'd15:light_data=7'b1000111;//F
           
           
           default:light_data=7'b0000000;//nothing
           endcase
           
       end

endmodule
