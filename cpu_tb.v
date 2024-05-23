`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 15:44:15
// Design Name: 
// Module Name: cpu_tb
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


module cpu_tb(

    );
    reg clk, rst;
        reg ConfirmCtrl=1'b0;
        reg [2:0] test_index;
        wire [15:0] led_data;
        wire [6:0] light_data2;
        wire [7:0]an;
        wire [6:0]light_data;
        reg start_pg=1'b0;
        reg rx=1'b0;
        wire tx;
        wire [7:0] io_rdata=12;
       CPU cpu_c(.clk(clk),.rst(rst),.ConfirmCtrl(ConfirmCtrl),.io_rdata(io_rdata),.light_data2(light_data2),
       .test_index(test_index),.led_data(led_data),.start_pg(start_pg),.rx(rx),
       .tx(tx),.an(an),.light_data(light_data));
        initial begin
         clk=1'b1;rst=1'b1;
         forever #5 clk=~clk;
         end
         initial begin
         
         #1300 ConfirmCtrl=1'b1;
         #1350 ConfirmCtrl=1'b0;
         #1600 ConfirmCtrl=1'b1;
         #1650 ConfirmCtrl=1'b0;
         end
endmodule
