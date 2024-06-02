`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/13 19:37:16
// Design Name: 
// Module Name: clkdiv
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

module debounceClkDiv(
	input wire clk,
	input wire clr,
	output wire DeClk
);
	reg [18:0] q;

	always @(posedge clk or posedge clr)
		begin
			if(clr==1'b1)
				q <= 0;
			else
				q <= q+1;
		end

	assign DeClk = q[18];

endmodule
