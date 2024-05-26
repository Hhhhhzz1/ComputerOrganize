`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 20:30:23
// Design Name: 
// Module Name: Led
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


module Led(
rst,LEDCtrl,write_data,led_data,clk

    );
 input rst,clk;
 input LEDCtrl;
 input[31:0]write_data;
 output reg[15:0] led_data;
 
 always@(negedge clk or negedge rst)begin
 if(rst==1'b0)led_data=16'b0;
 else begin
 if(LEDCtrl==1)led_data=write_data[15:0];
//else led_data=0;
 end
 
 end
    
endmodule
