`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 19:16:15
// Design Name: 
// Module Name: MemOrIO
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


module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl,shuma,ConfirmCtrl,test_index,rega7,signextend);
input mRead; // read memory, from Controller
input mWrite; // write memory, from Controller
input ioRead; // read IO, from Controller
input ioWrite; // write IO, from Controller
input[31:0] addr_in; // from alu_result in ALU
output[31:0] addr_out; // address to Data-Memory
input[31:0] m_rdata; // data read from Data-Memory
input[7:0] io_rdata; // data read from IO,8 bits bond bomakaiguan
output reg[31:0] r_wdata; // data to Decoder(register file)
input[31:0] r_rdata; // data read from Decoder(register file)
output reg[31:0] write_data; // data to memory or I/O（m_wdata, io_wdata）
output LEDCtrl; // LED Chip Select 
output shuma;
//output SwitchCtrl; // Switch Chip Selec
input ConfirmCtrl;//bond bomakaiguan
input[2:0] test_index;//bond bomakaiguan
input[31:0] rega7;//a7 from regiser
output signextend; //to registerfile

assign addr_out= addr_in;
assign signextend=(rega7==1)?1'b1:1'b0;
// The data wirte to register file may be from memory or io. // While the data is from io, it should be the lower 16bit of r_wdata. assign r_wdata = ？？？
// Chip select signal of Led and Switch are all active high;
always@(*)begin
if(ioRead)begin
if(rega7==32'h00000001||rega7==32'h00000003)r_wdata=io_rdata; //data
else if(rega7==32'h00000000)r_wdata=ConfirmCtrl; //confirm
else if(rega7==32'h00000002)r_wdata=test_index;//index
else r_wdata=32'b0;

end
else begin

r_wdata=m_rdata;


end


end



assign LEDCtrl= ((ioWrite==1)&&rega7==32'h00000004)?1'b1:1'b0;

assign shuma= ((ioWrite==1)&&rega7==32'h00000005)?1'b1:1'b0;
//assign SwitchCtrl= ((ioRead==1)&&addr_in==32'hfffffc62)?1'b1:1'b0;
always @* begin
if((mWrite==1)||(ioWrite==1))
//wirte_data could go to either memory or IO. where is it from?
write_data = r_rdata;
else
write_data = 32'hZZZZZZZZ;
end

endmodule
