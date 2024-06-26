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


module MemOrIO( mRead,mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl,ConfirmCtrl,test_index,rega7,data1);
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

//output SwitchCtrl; // Switch Chip Selec
input ConfirmCtrl;//bond bomakaiguan
input[2:0] test_index;//bond bomakaiguan
input[31:0] rega7;//a7 from regiser
output reg [31:0]data1;

assign addr_out= addr_in;
// The data wirte to register file may be from memory or io. // While the data is from io, it should be the lower 16bit of r_wdata. assign r_wdata = ？？？
// Chip select signal of Led and Switch are all active high;

always@(*)begin
if(ioRead)begin
if(rega7==1||rega7==3)begin 
if(rega7==1)
r_wdata={{24{io_rdata[7]}},io_rdata};
else r_wdata=io_rdata;
end
else if(rega7==0)r_wdata=ConfirmCtrl; //confirm
else if(rega7==2)
begin
r_wdata=test_index;//index
data1=test_index;
end
else r_wdata=0;
end
else if(mRead==1'b1)
r_wdata=m_rdata;



end

//always @(*) begin
//        if(ioRead)begin
//            if ((addr_in >= 32'hffff_f600) && (addr_in <= 32'hffff_f700)) begin//input data
//                r_wdata=io_rdata;
//            end
//            else if((addr_in >= 32'hffff_f500) && (addr_in <= 32'hffff_f600)) begin//input ctrl
//                r_wdata=ConfirmCtrl;
//            end
//            else if((addr_in >= 32'hffff_f400) && (addr_in <= 32'hffff_f500)) begin//input test_index
//                r_wdata=test_index;
//            end else
//                r_wdata= 0;
//        end
//        else if(mRead==1'b1)begin
//            r_wdata=m_rdata;
//        end
//   end





//assign SwitchCtrl= ((ioRead==1)&&addr_in==32'hfffffc62)?1'b1:1'b0;
always @(*) begin

if((mWrite==1)||(ioWrite==1))
//wirte_data could go to either memory or IO. where is it from?
write_data = r_rdata;

end

//always @(*) begin

//if((ioWrite==1)&&rega7==32'h00000004)
//LEDCtrl=1'b1;
//else if((ioWrite==1)&&rega7==32'h00000005)
//LEDCtrl=1'b0;
//end
assign LEDCtrl=
((ioWrite==1)&&rega7==4)
//((addr_in >= 32'hffff_f600) && ((addr_in <= 32'hffff_f790)) && (ioWrite == 1))
?1'b1:1'b0;
endmodule
