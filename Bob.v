`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/15 13:01:37
// Design Name: 
// Module Name: Bob
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
`define  DATASIZE	60
`define  BER		3  //INT
module Bob(
input           	    clk,      /*clock signal*/
input           	    rst,    
input					rand_ready,
input signed	[31:0]  randin,
input   		[7:0]	Astate,				/*state is to show working process*/
input 			[1:0]	qua_channel_in,		/*quantum channnel input*/
input 			[2:0]	pub_channel_in,		/*public  channnel input*/
output  		[7:0]	Bstate,				/*state is to show working process*/
output reg  	[1:0]   qua_channel_out,  	/*quantum channnel output*/
output reg 		[2:0]	pub_channel_out,	/*public  channnel output*/

output reg				rand_en,
output			[31:0]	Brandout,
output reg		[7:0]	Bcount,				/*counter belong to A*/
//input					ready,
output reg				valid,
output reg		[7:0]	Error,				/*the numbers of error*/
output  		[31:0]	secret_key,


output 			[1:0]	test_q,
output 					test_m,
output			[7:0]	test_r,
output			[7:0]	test_random1,
output			[7:0]	test_random2,
output			[7:0]	test_d,
output			[31:0]	test_temp_rand,
output			[31:0]	test_temp_randt
    );

reg	 		 	result[`DATASIZE-1:0];	//Expected choice 250bit
reg				result_temp[`DATASIZE-1:0];	//with data_coordination

reg 	[1:0]	qbit[`DATASIZE-1:0];	
reg         	mbase[`DATASIZE-1:0];
reg		[7:0]	random[`DATASIZE-1:0];

//state machine variable declaration
reg         [7:0]   st;

reg			[7:0]	d;	//the numbers of data after measure base

reg			[7:0]	temp_Error;
reg   		[31:0]  temp_rand;
reg   		[31:0]  temp_randt;
reg   		[31:0]  temp_randtt;
reg   		[31:0]  temp_randttt;
reg			[7:0]	temp;
reg			[7:0]	temp_array;	//work with new array product 

reg					flag_rand_en;	//Bob is receiver so no need to control the real rand_en
reg					flag_rand_rec;	//control receive rand data

reg			[5:0]	i;//work with for cycle

reg			[31:0]	matrix_in = 0;
wire		[11:0]	matrix_out;

reg			[31:0]	key_in = 0;
reg			[31:0]	key;	//the finally secret key

always@(posedge clk)
begin 
    //nxt_st = st;
    if(rst) 
    begin
		Bcount = 0;
		Error = 0;
		temp_Error = 0;
		st = 50;
		rand_en = 0;
		temp_rand = 0;
		temp = 0;
		temp_array = 0;
		d = 0;
		i = 0;
		/*
		mbase[0] = 0;
		mbase[1] = 0;
		mbase[2] = 1;
		mbase[3] = 0;
		mbase[4] = 1;
		mbase[5] = 1;
		mbase[6] = 1;
		mbase[7] = 0;
		mbase[8] = 1;
		mbase[9] = 1;
		mbase[10] = 0;
		mbase[11] = 1;
		*/
		
		qua_channel_out = 0;
		pub_channel_out = 0;
	end
	else 
	begin
		case (st)
			50:begin	//receive random data as mbase
				if(Astate == 0)
				begin
					rand_en = 1;
					if(rand_ready)	//delay for rand ready
					begin
						if(temp_rand != randin)
						begin
							rand_en = 0;	//pause rand product
							temp_rand = randin;
							mbase[Bcount] = temp_rand % 2;
							Bcount = Bcount + 1;
						end
						else;
			
						if(Bcount > `DATASIZE)	//`DATASIZE
						begin
							rand_en = 0;
							Bcount = 0;		//reset Bcount
							d = 0;			//reset d
							temp_rand = 0;	//reset temp_rand
							temp = 0;		//reset temp
							temp_array = 0;	//reset temp_array
							i = 0;
							st = 0;
						end
						else;
					end
					else;
				end
			end
			
			0:begin  	//quantum data start signal
				if(st == Astate)	//matching state
				begin
					if(pub_channel_in == 2'b01)
					begin
						pub_channel_out = 2'b10;
						st = st + 1;
					end
					else;
				end
				else;
			end
			
			1:begin		//delay time b is receiver
				if(st == Astate)	//match time
				begin
					st = st + 1;
				end
				else;
			end
			
			2:begin		//quantum data transmit
				if(Bcount < `DATASIZE)
				begin
					qbit[Bcount] = qua_channel_in;
					Bcount = Bcount + 1;
					st = st - 1;
				end
				else 
					st = st + 1;
			end
			
			3:begin //ending quantum data transmit start to transmit measure basement by b 
				Bcount = 0;		//clear counter
				if(st == Astate)	//matching state
					pub_channel_out = 2'b01;	
				else if(st == Astate - 1)  //A is faster
				begin
					if(pub_channel_in == 2'b10)
						st = st + 1;
					else;
				end
				else;
			end
			
			4:begin		//measure base send
				if(Bcount < `DATASIZE/4)	//25%
				begin
					pub_channel_out = mbase[Bcount];
					Bcount = Bcount + 1;
					st = st + 1;
				end
				else 
					st = st + 2;
			end
			
			5:begin		//delay time
				st = st - 1;
			end
			
			6:begin		//end measure base receiving and prepare for calculating
				Bcount = 0;		//clear counter
				temp_Error = 0;		//clear error number
				if(st == Astate)	//matching state
				begin
					if(pub_channel_in == 2'b01)
					begin
						pub_channel_out = 2'b10;
						st = st + 1;
					end
					else;
				end
				else;
			end
			
			7:begin		//delay time b is receiver
				if(st == Astate)	//match time
				begin
					st = st + 1;
				end
				else;
			end
			
			8:begin		//measure base calculate and receive results
				if(Bcount < `DATASIZE/4)	//25%
				begin
					if(qbit[Bcount] >= mbase[Bcount])
					begin
						if((qbit[Bcount] - mbase[Bcount])%2 == 1)
							temp_Error = (pub_channel_in == 3'b100) ? temp_Error : temp_Error + 1;//invalid data
						else 
						begin
							temp = ((qbit[Bcount] - mbase[Bcount]) > 1) ? 1 : 0;
							temp_Error = (pub_channel_in == temp) ? temp_Error : temp_Error + 1;//invalid data
						end
					end
					else
						temp_Error = (pub_channel_in == 3'b111) ? temp_Error : temp_Error + 1;  //negative number also invalid data
					Bcount = Bcount + 1;
					st = st - 1;
				end
				else 
				begin
					st = (temp_Error > `BER)? 50 : st + 1;  //if error is beyond ber must stop this transmittion
					Error = temp_Error;
				end
			end
			
			9:begin		//send the rest of the measure base
				if(st == Astate)	//matching state
					pub_channel_out = 2'b01;	
				else if(st == Astate - 1)  //A is faster
				begin
					if(pub_channel_in == 2'b10)
						st = st + 1;
					else;
				end
				else;
			end
			
			10:begin	//send the rest of the measure base
				if(Bcount < `DATASIZE)	//100%- 25% = 75%
				begin
					pub_channel_out = mbase[Bcount];
					Bcount = Bcount + 1;
					st = st + 1;
				end
				else 
				begin
					Bcount = 0;
					st = st + 2;
				end
			end	
			11:begin	//delay time
				st = st - 1;
			end
			
			12:begin	//remove 4 and 7 and add data to result[]
				if(st == Astate)	//match time
				begin
					if(Bcount < `DATASIZE)
					begin
						if((qbit[Bcount] - mbase[Bcount])%2 != 1)
						begin
							result[d] = ((qbit[Bcount] - mbase[Bcount])>1)?1:0;
							d = d + 1;
						end
						else;
						Bcount = Bcount + 1;
					end
					else
					st = st + 1;
				end
				else;
			end
			
			13:begin	//match d with alice by public channel b is receiver
				Bcount = 0;		//clear counter
				if(st == Astate)	//matching state
				begin
					if(pub_channel_in == 2'b01)
					begin
						pub_channel_out = 2'b10;
						st = st + 1;
					end
					else;
				end
				else;
			end
			
			14:begin		//delay time b is receiver
				if(st == Astate)	//match time
				begin
					st = st + 1;
				end
				else;
			end
			
			15:begin	//transmit 8 bit
				if(Bcount < 8)	//8 bit
				begin
					if(pub_channel_in == d[Bcount])
						Bcount = Bcount + 1;
					else
						st = 50;	//if d is wrong is beyond ber must stop this transmittion
					st = st - 1;
				end
				else 
				begin
					Bcount = 0;		//clear counter
					flag_rand_rec = 0;
					st = st + 1;
				end
			end
			
			16:begin		//product the first random sequence's first number
				temp = 0;		//clear temp
				flag_rand_en = 1;	//different with Alice
				
				if(rand_ready)	//delay for rand ready
				begin
					if(temp_rand != randin || flag_rand_rec == 1)
					begin
						temp_rand = (flag_rand_rec == 0) ? randin : temp_rand;
						flag_rand_rec = 1;
						if(temp_randttt == randin)
						begin
							if(Bcount == 0)
							begin
								temp_rand = randin;
								random[Bcount] = temp_rand % d;
								Bcount = Bcount + 1;
							end
							else
								;
						end
						else if(flag_rand_rec == 1&&temp_rand != randin)
						begin
							flag_rand_rec = 0;
							st = st + 1;
						end
						else
							;
					end
					else;
				end
				else;
			end
			
			17:begin		//product the first random sequence
				flag_rand_en = 1;	//different with Alice
				if(rand_ready)	//delay for rand ready
				begin
					if(temp_rand != randin|| flag_rand_rec == 1)
					begin
						temp_rand = (flag_rand_rec == 0) ? randin : temp_rand;
						flag_rand_rec = 1;
						if(temp_randttt == randin)
						begin
							if(temp > Bcount || Bcount == 1)
							begin
								temp = 0;
								temp_rand = randin;
								st = st + 1;
							end
							else
								;
						end
						else;
					end
					else
					;
				end
				else;
			end
			
			18:begin
				flag_rand_rec = 0;
					if(temp < Bcount)
						begin
							if(random[temp] == (temp_rand % d))	//repetition
							begin
								random[Bcount] = 250;
								temp = Bcount - 1;
							end
							else
								random[Bcount] = 0;
							temp = temp + 1;
					
						end
						else if(temp == Bcount)
						begin
							temp = temp + 2;
							if(random[Bcount] != 250)
							begin
								random[Bcount] = temp_rand % d;
								Bcount = Bcount + 1;
							end
							else		//repetition
								;
						end
						else if(temp > Bcount )
						begin
							if(Bcount >= d)		//meet the conditions
							begin
								temp_rand = 0;	//reset temp_rand
								flag_rand_en = 0;		//pause rand product
								temp = Bcount;
								flag_rand_rec = 0;
								st = st + 1;
							end
							else
								st = st - 1;
						end
						else;
					
						
					
			end
			19:begin	//match the parity of random sequence's first number B is sender
				st = (d <= 4) ? 50 : st;		//d mustn't too small
				temp_array = 0;
				Bcount = 0;
				
				if(st == Astate)	//matching state
					pub_channel_out = 2'b01;	
				else if(st == Astate - 1)  //A is faster
				begin
					if(pub_channel_in == 2'b10)
						st = st + 1;
					else;
				end
				else;
			end
				
			20:begin	//match the parity of random sequence's first number B is sender
				if(Bcount < temp)
				begin
					if(Bcount == 0)
					begin
						if(d % 2 == 1)
						begin
							pub_channel_out[0] = result[random[Bcount]] + result[random[Bcount + 1]] + result[random[Bcount + 2]];
							Bcount = Bcount + 3;
						end
						else
						begin
							pub_channel_out[0] = result[random[Bcount]] + result[random[Bcount + 1]];
							Bcount = Bcount + 2;
						end
					end
					else
					begin
						if(Bcount == 3)		//receive A's sending parity and put in new array
						begin
							if(pub_channel_in[0] == result[random[Bcount - 3]] + result[random[Bcount - 2]] + result[random[Bcount - 1]])
							begin
								result_temp[temp_array] 	= result[random[Bcount - 3]];
								result_temp[temp_array + 1] = result[random[Bcount - 2]];
								result_temp[temp_array + 2] = result[random[Bcount - 1]];
								temp_array = temp_array + 3;
							end
							else
								d = d - 3;
						end
						
						else if(Bcount != 3)
						begin
							if(pub_channel_in[0] == result[random[Bcount - 2]] + result[random[Bcount - 1]])
							begin
								result_temp[temp_array] 	= result[random[Bcount - 2]];
								result_temp[temp_array + 1] = result[random[Bcount - 1]];
								temp_array = temp_array + 2;
							end
							else
								d = d - 2;
						end
						
						else;
						
						pub_channel_out[0] = result[random[Bcount]] + result[random[Bcount + 1]];	//sending new parity
						Bcount = Bcount + 2;
					end
					
					st = st + 1;
				end
				
				else
				begin
					if(pub_channel_in[0] == result[random[Bcount - 2]] + result[random[Bcount - 1]])
					begin
						result_temp[temp_array] 	= result[random[Bcount - 2]];
						result_temp[temp_array + 1] = result[random[Bcount - 1]];
						temp_array = temp_array + 2;
					end
					else
						d = d - 2;
					
					Bcount = 0;		//clear counter
					st = st + 2;
				end
				
			end
			
			
			21:begin	//delay time
				st = st - 1;
			end
			
			
			22:begin		//product the second random sequence's first number
				temp = 0;		//clear temp
				flag_rand_en = 1;	//different with Alice
				
				if(rand_ready)	//delay for rand ready
				begin
					if(temp_rand != randin || flag_rand_rec == 1)//((temp_rand != randin)&&(temp_rand == temp_randtt))//
					begin
						temp_rand = (flag_rand_rec == 0) ? randin : temp_rand;
						flag_rand_rec = 1;
						if(temp_randttt == randin)
						begin
							
							if(Bcount == 0)
							begin
								temp_rand = randin;
								random[Bcount] = temp_rand % d;
								Bcount = Bcount + 1;
							end
							else
								;
						end
						else if(flag_rand_rec == 1&&temp_rand != randin)
						begin
							flag_rand_rec = 0;
							st = st + 1;
						end
						else
							;
					end
					else;
				end
				else;
				
			end
			
			23:begin		//product the second random sequence
				flag_rand_en = 1;	//different with Alice
				if(rand_ready)	//delay for rand ready
				begin
					if(temp_rand != randin|| flag_rand_rec == 1)//((temp_rand != randin)&&(temp_rand == temp_randtt))
					begin
						temp_rand = (flag_rand_rec == 0) ? randin : temp_rand;
						flag_rand_rec = 1;
						if(temp_randttt == randin)
						begin
							if(temp > Bcount || Bcount == 1)
							begin
								temp = 0;
								temp_rand = randin;
								st = st + 1;
							end
							else
								;
						end
						else;
					end
					else
					;
				end
				else;
			end
			
			24:begin
				flag_rand_rec = 0;
					if(temp < Bcount)
						begin
							if(random[temp] == (temp_rand % d))	//repetition
							begin
								random[Bcount] = 250;
								temp = Bcount - 1;
							end
							else
								random[Bcount] = 0;
							temp = temp + 1;
					
						end
						else if(temp == Bcount)
						begin
							temp = temp + 2;
							if(random[Bcount] != 250)
							begin
								random[Bcount] = temp_rand % d;
								Bcount = Bcount + 1;
							end
							else		//repetition
								;
						end
						else if(temp > Bcount )
						begin
							if(Bcount >= d)		//meet the conditions
							begin
								temp_rand = 0;	//reset temp_rand
								flag_rand_en = 0;		//pause rand product
								temp = Bcount;
								flag_rand_rec = 0;
								st = st + 1;
							end
							else
								st = st - 1;
						end
						else;
					
			end
			
			25:begin	//match the parity of random sequence's second number B is sender
				st = (d <= 4) ? 50 : st;		//d mustn't too small
				temp_array = 0;
				Bcount = 0;
				
				if(st == Astate)	//matching state
					pub_channel_out = 2'b01;	
				else if(st == Astate - 1)  //A is faster
				begin
					if(pub_channel_in == 2'b10)
						st = st + 1;
					else;
				end
				else;
			end
			
			26:begin	//match the parity of random sequence's second number B is sender
				if(Bcount < temp)
				begin
					if(Bcount == 0)
					begin
						if(d % 2 == 1)
						begin
							pub_channel_out[0] = result_temp[random[Bcount]] + result_temp[random[Bcount + 1]] + result_temp[random[Bcount + 2]];
							Bcount = Bcount + 3;
						end
						else
						begin
							pub_channel_out[0] = result_temp[random[Bcount]] + result_temp[random[Bcount + 1]];
							Bcount = Bcount + 2;
						end
					end
					else
					begin
						if(Bcount == 3)		//receive A's sending parity and put in new array
						begin
							if(pub_channel_in[0] == result_temp[random[Bcount - 3]] + result_temp[random[Bcount - 2]] + result_temp[random[Bcount - 1]])
							begin
								result[temp_array] 	= result_temp[random[Bcount - 3]];
								result[temp_array + 1] = result_temp[random[Bcount - 2]];
								result[temp_array + 2] = result_temp[random[Bcount - 1]];
								temp_array = temp_array + 3;
							end
							else
								d = d - 3;
						end
						
						else if(Bcount != 3)
						begin
							if(pub_channel_in[0] == result_temp[random[Bcount - 2]] + result_temp[random[Bcount - 1]])
							begin
								result[temp_array] 	= result_temp[random[Bcount - 2]];
								result[temp_array + 1] = result_temp[random[Bcount - 1]];
								temp_array = temp_array + 2;
							end
							else
								d = d - 2;
						end
						
						else;
						
						pub_channel_out[0] = result_temp[random[Bcount]] + result_temp[random[Bcount + 1]];	//sending new parity
						Bcount = Bcount + 2;
					end
					
					st = st + 1;
				end
				
				else
				begin
					if(pub_channel_in[0] == result_temp[random[Bcount - 2]] + result_temp[random[Bcount - 1]])
					begin
						result[temp_array] 	   = result_temp[random[Bcount - 2]];
						result[temp_array + 1] = result_temp[random[Bcount - 1]];
						temp_array = temp_array + 2;
					end
					else
						d = d - 2;
					
					Bcount = 0;		//clear counter
					st = st + 2;
				end
				
			end
			
			
			27:begin	//delay time
				st = st - 1;
			end
			
			
			28:begin		//product the third random sequence's first number
				temp = 0;		//clear temp
				flag_rand_en = 1;	//different with Alice
				
				if(rand_ready)	//delay for rand ready
				begin
					if(temp_rand != randin || flag_rand_rec == 1)//((temp_rand != randin)&&(temp_rand == temp_randtt))//
					begin
						temp_rand = (flag_rand_rec == 0) ? randin : temp_rand;
						flag_rand_rec = 1;
						if(temp_randttt == randin)
						begin
							
							if(Bcount == 0)
							begin
								temp_rand = randin;
								random[Bcount] = temp_rand % d;
								Bcount = Bcount + 1;
							end
							else
								;
						end
						else if(flag_rand_rec == 1&&temp_rand != randin)
						begin
							flag_rand_rec = 0;
							st = st + 1;
						end
						else
							;
					end
					else;
				end
				else;
			end
			
			29:begin		//product the third random sequence
				flag_rand_en = 1;	//different with Alice
				if(rand_ready)	//delay for rand ready
				begin
					if(temp_rand != randin|| flag_rand_rec == 1)//((temp_rand != randin)&&(temp_rand == temp_randtt))
					begin
						temp_rand = (flag_rand_rec == 0) ? randin : temp_rand;
						flag_rand_rec = 1;
						if(temp_randttt == randin)
						begin
							if(temp > Bcount || Bcount == 1)
							begin
								temp = 0;
								temp_rand = randin;
								st = st + 1;
							end
							else
								;
						end
						else;
					end
					else
					;
				end
				else;
			end
			
			30:begin
				flag_rand_rec = 0;
					if(temp < Bcount)
						begin
							if(random[temp] == (temp_rand % d))	//repetition
							begin
								random[Bcount] = 250;
								temp = Bcount - 1;
							end
							else
								random[Bcount] = 0;
							temp = temp + 1;
					
						end
						else if(temp == Bcount)
						begin
							temp = temp + 2;
							if(random[Bcount] != 250)
							begin
								random[Bcount] = temp_rand % d;
								Bcount = Bcount + 1;
							end
							else		//repetition
								;
						end
						else if(temp > Bcount )
						begin
							if(Bcount >= d)		//meet the conditions
							begin
								temp_rand = 0;	//reset temp_rand
								flag_rand_en = 0;		//pause rand product
								temp = Bcount;
								flag_rand_rec = 0;
								st = st + 1;
							end
							else
								st = st - 1;
						end
						else;
			end
			
			31:begin	//match the parity of random sequence's third number B is sender
				st = (d <= 4) ? 50 : st;		//d mustn't too small
				temp_array = 0;
				Bcount = 0;
				
				if(st == Astate)	//matching state
					pub_channel_out = 2'b01;	
				else if(st == Astate - 1)  //A is faster
				begin
					if(pub_channel_in == 2'b10)
						st = st + 1;
					else;
				end
				else;
			end
				
			32:begin	//match the parity of random sequence's third number B is sender
				if(Bcount < temp)
				begin
					if(Bcount == 0)
					begin
						if(d % 2 == 1)
						begin
							pub_channel_out[0] = result[random[Bcount]] + result[random[Bcount + 1]] + result[random[Bcount + 2]];
							Bcount = Bcount + 3;
						end
						else
						begin
							pub_channel_out[0] = result[random[Bcount]] + result[random[Bcount + 1]];
							Bcount = Bcount + 2;
						end
					end
					else
					begin
						if(Bcount == 3)		//receive A's sending parity and put in new array
						begin
							if(pub_channel_in[0] == result[random[Bcount - 3]] + result[random[Bcount - 2]] + result[random[Bcount - 1]])
							begin
								result_temp[temp_array] 	= result[random[Bcount - 3]];
								result_temp[temp_array + 1] = result[random[Bcount - 2]];
								result_temp[temp_array + 2] = result[random[Bcount - 1]];
								temp_array = temp_array + 3;
							end
							else
								d = d - 3;
						end
						
						else if(Bcount != 3)
						begin
							if(pub_channel_in[0] == result[random[Bcount - 2]] + result[random[Bcount - 1]])
							begin
								result_temp[temp_array] 	= result[random[Bcount - 2]];
								result_temp[temp_array + 1] = result[random[Bcount - 1]];
								temp_array = temp_array + 2;
							end
							else
								d = d - 2;
						end
						
						else;
						
						pub_channel_out[0] = result[random[Bcount]] + result[random[Bcount + 1]];	//sending new parity
						Bcount = Bcount + 2;
					end
					
					st = st + 1;
				end
				
				else
				begin
					if(pub_channel_in[0] == result[random[Bcount - 2]] + result[random[Bcount - 1]])
					begin
						result_temp[temp_array] 	= result[random[Bcount - 2]];
						result_temp[temp_array + 1] = result[random[Bcount - 1]];
						temp_array = temp_array + 2;
					end
					else
						d = d - 2;
					
					Bcount = 0;		//clear counter
					st = st + 2;
				end
				
			end
			
			33:begin	//delay time
				st = st - 1;
			end
			
			34:begin		//product the forth random sequence's first number
				temp = 0;		//clear temp
				flag_rand_en = 1;	//different with Alice
				
				if(rand_ready)	//delay for rand ready
				begin
					if(temp_rand != randin || flag_rand_rec == 1)//((temp_rand != randin)&&(temp_rand == temp_randtt))//
					begin
						temp_rand = (flag_rand_rec == 0) ? randin : temp_rand;
						flag_rand_rec = 1;
						if(temp_randttt == randin)
						begin
							
							if(Bcount == 0)
							begin
								temp_rand = randin;
								random[Bcount] = temp_rand % d;
								Bcount = Bcount + 1;
							end
							else
								;
						end
						else if(flag_rand_rec == 1&&temp_rand != randin)
						begin
							flag_rand_rec = 0;
							st = st + 1;
						end
						else
							;
					end
					else;
				end
				else;
			end
			
			35:begin		//product the forth random sequence
				flag_rand_en = 1;	//different with Alice
				if(rand_ready)	//delay for rand ready
				begin
					if(temp_rand != randin|| flag_rand_rec == 1)//((temp_rand != randin)&&(temp_rand == temp_randtt))
					begin
						temp_rand = (flag_rand_rec == 0) ? randin : temp_rand;
						flag_rand_rec = 1;
						if(temp_randttt == randin)
						begin
							if(temp > Bcount || Bcount == 1)
							begin
								temp = 0;
								temp_rand = randin;
								st = st + 1;
							end
							else
								;
						end
						else;
					end
					else
					;
				end
				else;
			end
			
			36:begin
				flag_rand_rec = 0;
					if(temp < Bcount)
						begin
							if(random[temp] == (temp_rand % d))	//repetition
							begin
								random[Bcount] = 250;
								temp = Bcount - 1;
							end
							else
								random[Bcount] = 0;
							temp = temp + 1;
					
						end
						else if(temp == Bcount)
						begin
							temp = temp + 2;
							if(random[Bcount] != 250)
							begin
								random[Bcount] = temp_rand % d;
								Bcount = Bcount + 1;
							end
							else		//repetition
								;
						end
						else if(temp > Bcount )
						begin
							if(Bcount >= d)		//meet the conditions
							begin
								temp_rand = 0;	//reset temp_rand
								flag_rand_en = 0;		//pause rand product
								temp = Bcount;
								flag_rand_rec = 0;
								st = st + 1;
							end
							else
								st = st - 1;
						end
						else;
			end
			
			37:begin	//match the parity of random sequence's forth number B is sender
				st = (d <= 4) ? 50 : st;		//d mustn't too small
				temp_array = 0;
				Bcount = 0;
				
				if(st == Astate)	//matching state
					pub_channel_out = 2'b01;	
				else if(st == Astate - 1)  //A is faster
				begin
					if(pub_channel_in == 2'b10)
						st = st + 1;
					else;
				end
				else;
			end
			
			38:begin	//match the parity of random sequence's forth number B is sender
				if(Bcount < temp)
				begin
					if(Bcount == 0)
					begin
						if(d % 2 == 1)
						begin
							pub_channel_out[0] = result_temp[random[Bcount]] + result_temp[random[Bcount + 1]] + result_temp[random[Bcount + 2]];
							Bcount = Bcount + 3;
						end
						else
						begin
							pub_channel_out[0] = result_temp[random[Bcount]] + result_temp[random[Bcount + 1]];
							Bcount = Bcount + 2;
						end
					end
					else
					begin
						if(Bcount == 3)		//receive A's sending parity and put in new array
						begin
							if(pub_channel_in[0] == result_temp[random[Bcount - 3]] + result_temp[random[Bcount - 2]] + result_temp[random[Bcount - 1]])
							begin
								result[temp_array] 	= result_temp[random[Bcount - 3]];
								result[temp_array + 1] = result_temp[random[Bcount - 2]];
								result[temp_array + 2] = result_temp[random[Bcount - 1]];
								temp_array = temp_array + 3;
							end
							else
								d = d - 3;
						end
						
						else if(Bcount != 3)
						begin
							if(pub_channel_in[0] == result_temp[random[Bcount - 2]] + result_temp[random[Bcount - 1]])
							begin
								result[temp_array] 	= result_temp[random[Bcount - 2]];
								result[temp_array + 1] = result_temp[random[Bcount - 1]];
								temp_array = temp_array + 2;
							end
							else
								d = d - 2;
						end
						
						else;
						
						pub_channel_out[0] = result_temp[random[Bcount]] + result_temp[random[Bcount + 1]];	//sending new parity
						Bcount = Bcount + 2;
					end
					
					st = st + 1;
				end
				
				else
				begin
					if(pub_channel_in[0] == result_temp[random[Bcount - 2]] + result_temp[random[Bcount - 1]])
					begin
						result[temp_array] 	   = result_temp[random[Bcount - 2]];
						result[temp_array + 1] = result_temp[random[Bcount - 1]];
						temp_array = temp_array + 2;
					end
					else
						d = d - 2;
					
					Bcount = 0;		//clear counter
					st = st + 2;
				end
				
			end
			
			
			39:begin	//delay time
				st = st - 1;
			end
			
			40:begin	//start	matrix_calculation wait for receiving data
				if(i < 32)
				begin
					// matrix_in[i] = (i <= d-1) ? result[i] : 0;	
					key_in[i] = (i <= d-1) ? result[i] : 0;	
					i = i + 1;
				end
				else
				begin
					st = st + 1;
				end
			end
		
			41:begin	//receive data after matrix and stop matrix_calculation
				key = key_in;
				st = st + 1;

			end
			
			42:begin	//A send key
				//st = (ready == 1) ? 50 : st;
				st = (Astate == 50) ? 50 : st;
			end
			
			
			
			default:begin
				st = st + 1;
			end
		endcase
	end
end

always @ (posedge clk) valid <=  (st == 42)  ; //告诉下位机数据有效可以取走

always @ (posedge clk) begin temp_randt <= temp_rand ; temp_randtt <= temp_randt ;temp_randttt <= temp_randtt ;end

assign Bstate = st;

assign test_q = qbit[0];	//qbit[]
assign test_m = mbase[0];	//mbase[]
assign test_r = result[5];	//random[]
assign Brandout = temp_rand;	//temp_rand

assign secret_key = (Error == 0)?key:0;

assign test_random1 = random[0];
assign test_random2 = random[1];

assign test_d = d;
assign test_temp_rand = temp_rand;
assign test_temp_randt = temp_randttt;

// matrix_calculation  MB (
//                 .A        ( matrix_in ),
//                 .C     ( matrix_out )
//                 );

endmodule
