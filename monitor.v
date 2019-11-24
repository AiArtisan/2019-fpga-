`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/06 18:42:18
// Design Name: 
// Module Name: test
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


module monitor (clk,a,SW,b,sum,thre); 
input clk;
input [1:0] a; 
input [7:0] SW;
output reg [1:0] b; 
output [7:0] sum;
output [7:0] thre;
reg [7:0] i=0;
wire [7:0] SWvalue;
reg [7:0] sw10;

always@(posedge clk)  begin
    case(SW)
    8'b00000000:sw10<=8'd0;
    8'b00000001:sw10<=8'd1;
    8'b00000010:sw10<=8'd2;
    8'b00000011:sw10<=8'd3;
    8'b00000100:sw10<=8'd4;
    8'b00000101:sw10<=8'd5;
    8'b00000110:sw10<=8'd6;
    8'b00000111:sw10<=8'd7;
    8'b00001000:sw10<=8'd8;
    8'b00001001:sw10<=8'd9;
    8'b00010000:sw10<=8'd10;
    8'b00010001:sw10<=8'd11;
    8'b00010010:sw10<=8'd12;
    8'b00010011:sw10<=8'd13;
    8'b00010100:sw10<=8'd14;
    8'b00010101:sw10<=8'd15;
    8'b00010110:sw10<=8'd16;
    8'b00010111:sw10<=8'd17;
    8'b00011000:sw10<=8'd18;
    8'b00011001:sw10<=8'd19;
    8'b00100000:sw10<=8'd20;
    8'b00100001:sw10<=8'd21;
    8'b00100010:sw10<=8'd22;
    8'b00100011:sw10<=8'd23;
    8'b00100100:sw10<=8'd24;
    8'b00100101:sw10<=8'd25;
    8'b00100110:sw10<=8'd26;
    8'b00100111:sw10<=8'd27;
    8'b00101000:sw10<=8'd28;
    8'b00101001:sw10<=8'd29;
    8'b00110000:sw10<=8'd30;
    8'b00110001:sw10<=8'd31;
    8'b00110010:sw10<=8'd32;
    8'b00110011:sw10<=8'd33;
    8'b00110100:sw10<=8'd34;
    8'b00110101:sw10<=8'd35;
    8'b00110110:sw10<=8'd36;
    8'b00110111:sw10<=8'd37;
    8'b00111000:sw10<=8'd38;
    8'b00111001:sw10<=8'd39;
    8'b01000000:sw10<=8'd40;
    8'b01000001:sw10<=8'd41;
    8'b01000010:sw10<=8'd42;
    8'b01000011:sw10<=8'd43;
    8'b01000100:sw10<=8'd44;
    8'b01000101:sw10<=8'd45;
    8'b01000110:sw10<=8'd46;
    8'b01000111:sw10<=8'd47;
    8'b01001000:sw10<=8'd48;
    8'b01001001:sw10<=8'd49;
    8'b01010000:sw10<=8'd50;
    8'b01010001:sw10<=8'd51;
    8'b01010010:sw10<=8'd52;
    8'b01010011:sw10<=8'd53;
    8'b01010100:sw10<=8'd54;
    8'b01010101:sw10<=8'd55;
    8'b01010110:sw10<=8'd56;
    8'b01010111:sw10<=8'd57;
    8'b01011000:sw10<=8'd58;
    8'b01011001:sw10<=8'd59;
    8'b01100000:sw10<=8'd60;
    8'b01100001:sw10<=8'd61;
    8'b01100010:sw10<=8'd62;
    8'b01100011:sw10<=8'd63;
    8'b01100100:sw10<=8'd64;
    8'b01100101:sw10<=8'd65;
    8'b01100110:sw10<=8'd66;
    8'b01100111:sw10<=8'd67;
    8'b01101000:sw10<=8'd68;
    8'b01101001:sw10<=8'd69;
    8'b01110000:sw10<=8'd70;
    8'b01110001:sw10<=8'd71;
    8'b01110010:sw10<=8'd72;
    8'b01110011:sw10<=8'd73;
    8'b01110100:sw10<=8'd74;
    8'b01110101:sw10<=8'd75;
    8'b01110110:sw10<=8'd76;
    8'b01110111:sw10<=8'd77;
    8'b01111000:sw10<=8'd78;
    8'b01111001:sw10<=8'd79;
    8'b10000000:sw10<=8'd80;
    8'b10000001:sw10<=8'd81;
    8'b10000010:sw10<=8'd82;
    8'b10000011:sw10<=8'd83;
    8'b10000100:sw10<=8'd84;
    8'b10000101:sw10<=8'd85;
    8'b10000110:sw10<=8'd86;
    8'b10000111:sw10<=8'd87;
    8'b10001000:sw10<=8'd88;
    8'b10001001:sw10<=8'd89;
    8'b10010000:sw10<=8'd90;
    8'b10010001:sw10<=8'd91;
    8'b10010010:sw10<=8'd92;
    8'b10010011:sw10<=8'd93;
    8'b10010100:sw10<=8'd94;
    8'b10010101:sw10<=8'd95;
    8'b10010110:sw10<=8'd96;
    8'b10010111:sw10<=8'd97;
    8'b10011000:sw10<=8'd98;
    8'b10011001:sw10<=8'd99;
    default:sw10<=8'd100;
    endcase
    end
always @ (posedge clk)begin
      if(i == 0)
      begin
          b <= (SW==0)? a : a+1;
          i <= i+1;
      end
      else if (i< SWvalue)
      begin
          b <= a+1;
          i <=i+1;
      end
      else if (i<99)
      begin
          b <= a;
          i <=i+1;
      end
      else
      begin
          b <= a;
          i <= 0;
          
      end
end


assign SWvalue = sw10;
assign sum = i;
assign thre=SWvalue;
endmodule