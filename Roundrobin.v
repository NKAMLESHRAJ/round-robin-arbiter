`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2020 02:52:37 PM
// Design Name: 
// Module Name: Roundrobin
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


module Roundrobin(input rst,clk,ack,[3:0]req,output [3:0]grant);
wire [3:0]token,out1,out2,out3,out4;
wire q;

ring r1(.rst(rst), .clk(q),.token(token));
dff d1(.clk(clk),.d(ack),.q(q));

pri p1(.en(token[0]),.in({req[1],req[2],req[3],req[0]}),.out(out1));
pri p2(.en(token[1]),.in({req[2],req[3],req[0],req[1]}),.out(out2));
pri p3(.en(token[2]),.in({req[3],req[0],req[1],req[2]}),.out(out3));
pri p4(.en(token[3]),.in({req[0],req[1],req[2],req[3]}),.out(out4));
or o0(grant[0],out1[0],out2[3],out3[2],out4[1]);
or o1(grant[1],out1[1],out2[0],out3[3],out4[2]);
or o2(grant[2],out1[2],out2[1],out3[0],out4[3]);
or o3(grant[3],out1[3],out2[2],out3[1],out4[0]);

endmodule

module pri(input en,[3:0]in,output reg [3:0]out);
always@(en,in)
begin
if(!en)
out<=0;
else
begin
if(in[3])
out<=4'b1000;
else if(in[2])
out<=4'b0100;
else if(in[1])
out<=4'b0010;
else
out<=4'b0001;
end
end
endmodule

module ring(input rst,clk,output reg[3:0]token);
always@(posedge clk)
begin
if(rst)
    token<=4'b0001;
else
   token<={token[0],token[3:1]};
end
endmodule

module dff(input clk,d,output reg q);
always@(posedge clk)
begin
 q<=d;
 end
endmodule

