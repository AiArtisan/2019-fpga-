`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/21 10:02:43
// Design Name: 
// Module Name: Random_seed_generator
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

//`define SEED 32'd100

module Random_seed_generator(
input               clk,      /*clock signal*/
input               rst,
input				en,
input   signed    [31:0]    seed,     
output            [7:0]     state,
output                      flag_wr,
output 						rand_ready,
output  signed    [31:0]    result  /*random number output*/
    );

reg 				ready;

reg signed  [31:0]  SEED = 32'd200;
	
reg signed  [31:0]  product;
reg signed  [31:0]  temp;
reg signed  [31:0]  temp_2;
reg signed  [31:0]  temp_3;
reg signed  [32:0]  temp_r;

//(*mark_debug = "true"*)
reg signed  [31:0]  temp_t;
reg signed  [31:0]  temp_tt;


reg signed  [31:0]  temp_ttt;

reg signed  [31:0]  temp_xor;
//ram相关声明
reg                 wr;
reg         [9:0]   sel;
reg signed  [31:0]  num;
wire        [31:0]  outp;

//状�?�机相关声明
reg         [7:0]   st;
//reg         [7:0]   nxt_st;
reg                 flag_nxt;
reg                 flag_sed;

reg         [9:0]   i = 1;
reg         [9:0]   index;

//always @ (posedge clk) if(~rst_n) st <= 0;else ;//st <= nxt_st;

always@(posedge clk)
begin 
    //nxt_st = st;
     if(rst) 
     begin
        st = 0;
        index = 0;
        flag_sed = 0;
        i = 1;
        temp_t = 1;
		ready = 0;
        SEED = seed;
        temp_xor = 0;
        //temp = seed;
     end
     else 
	 begin
		if(en)
		begin
		case (st)
		0:begin  //void srand(int seed)
            if(i == 1)
            begin
                if(flag_sed == 0)
                begin
                    temp = SEED;    	//seed
					temp_tt = SEED;    //seed
                    flag_sed = 1;   //�?但打�? 就不关闭 表示种子只使用一�?
                end
                else
                begin
                    temp = temp_ttt;
					temp_tt = temp_ttt;
                end
                    
            end
            else
            ;
            if(i<623+1 && i>0)
            begin
                temp_r = (temp) >>> 30;
                temp_t = (1812433253 * (temp ^ temp_r[31:0]) + i) & 32'hffff_ffff ;
                temp   = temp_t;
                sel = i;   //写入的序�?
                wr  = 1;    //写入
                num = temp_t;
                
                
            end
            else if(i>=624)
            begin
                //i = 0;
                sel = 0;   //写入的序�?
                wr  = 1;    //写入
                num = temp_tt; 
                st = (index == 0)? 1 :10;
                flag_nxt = 1;
            end
            else
            ;
            i = i+1;
        end
        1,3,5,8,9:begin       //void generate()
            ready = 0;
			if(st < 8)
            begin
                i  = (flag_nxt == 1) ? 0 : i;
                flag_nxt = 0; 
                wr = 0;    //读入
                if(st == 1)
                begin
                    sel = i;   //读入的序�?
                    
                end
                else if(st == 3)
                begin
                    sel = (i + 1) % 624;
                    temp = outp;  //不能立即读出�? 等到下个周期在读
                                         
                end
                else
                begin
                    sel = (i + 397) % 624;
                    temp_2 = outp;
                    
                end
                st = st + 1;
            end
            else if(st == 8)
            begin
                temp_3 = outp;  
                temp_t = (temp & 32'h80000000) + (temp_2 & 32'h7fffffff);
                temp_r = (temp_t) >>> 1;
                temp_tt = temp_3 ^ (temp_r);
                if (temp_t & 1)
                    temp_tt = temp_tt ^ 32'd2567483615;
                else;
                i = i + 1;
                st = st + 1;
                
            end
            else
            begin
                
                sel = i-1;   //写入的序�?
                num = temp_tt;
                wr  = 1;    //写入
                st = (i < 624) ? 1 : 10;
            end
            
                
        end
        10,12:begin       //rand()
            //i  = 1; 
            if(st == 10)
            begin 
                wr = 0;    //读入
                sel = index;   //读入的序�?
                st = st + 1;
            end
            else
            begin
                temp_t = outp;
                //test_pins
                //temp_ttt = outp;
                
                temp_r = temp_t >>> 11;
                temp_t = temp_t ^  (temp_r[31:0]);
                temp_t = temp_t ^ ((temp_t <<< 7 ) & 32'd2636928640);
                temp_t = temp_t ^ ((temp_t <<< 15) & 32'd4022730752);
                temp_r = temp_t >>>18;
                temp_ttt = (temp_t ^ temp_r[31:0]) ^ temp_xor;

                temp_xor = temp_t ^ temp_r[31:0];

                index = (index + 1) % 624;
                
                
                i = 1;
                st = 100;    //是否继续产生 在这插入！！
                //sel = 0;   //写入的序�?
                //num = temp_ttt;
                //wr  = 1;    //写入
                
            end
            
        end
        100:begin       //读取测试
            st = 0; 
			ready = 1;
            //wr = 0;    //读入
            //sel = 0;   //读入的序�?
			//st = st + 1;
        end
		101:begin       //读取测试
            st = 0;
        end
        default:begin  //delay()
             st = st + 1; //延时�?个时�?
        end
		//product = temp_t;
		endcase
		end		//en end
		else;
	 end
end
assign result  		= temp_ttt;
assign state   		= st;
assign flag_wr 		= wr;
assign rand_ready	= ready;
ram_MT ram1(
           .clk ( clk ),
           .wr  ( wr ), 
           .sel ( sel ),
           .num ( num ),
           .result ( outp )
           );
endmodule
