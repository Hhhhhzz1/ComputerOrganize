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
    input[15:0]write_data;
    output reg[3:0]an;
    output reg[6:0] light_data;
    reg [15:0]data;
    always@(negedge clk or negedge rst) begin
     if(rst==1'b0)data=0;
    else 
    if(LEDCtrl==1)data=write_data;
//    else data=16'h0000;
    end
    
    reg[18:0] clkdiv;
    reg[3:0] display;// diaplay state
    always @(posedge clk ) begin
        clkdiv<=clkdiv+1;
    end
    
    wire [1:0] sign;
    assign sign=clkdiv[18:17];
    always @(*) begin
    if(rst==1'b0)
      an=4'b1000;
    else begin
         case (sign)
          2'b00: an=4'b1000;
         2'b01: an=4'b0100;
         2'b10: an=4'b0010; 
         2'b11: an=4'b0001;  
    endcase
    end
    end
    
    always @(*)begin
     case(sign)
      2'b00: display=data[15:12];
      2'b01: display=data[11:8];
      2'b10: display=data[7:4];
      2'b11: display=data[3:0];
     endcase 
    end    
     always @(*) begin
           case (display)
           4'd0:light_data=7'b1111110;//0  
           4'd1:light_data=7'b0110000;//1
           4'd2:light_data=7'b1101101;//2
           4'd3:light_data=7'b1111001;//3
           4'd4:light_data=7'b0110011;//4
           4'd5:light_data=7'b1011011;//5
           4'd6:light_data=7'b1011111;//6
           4'd7:light_data=7'b1110000;//7
           4'd8:light_data=7'b1111111;//8
           4'd9:light_data=7'b1110011;//9
           
           4'd10:light_data=7'b1110111;//A
           4'd11:light_data=7'b0011111;//b
           4'd12:light_data=7'b1001110;//c
           4'd13:light_data=7'b0111101;//d
           4'd14:light_data=7'b1101111;//e
           4'd15:light_data=7'b1000111;//F
           
           
           default:light_data=7'b0000000;//nothing to test
           endcase
           
       end

endmodule
