`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/10 19:24:19
// Design Name: 
// Module Name: Quantum_Knight_top
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


module Quantum_Knight_top(
input               CLK,      /*clock signal*/
input				RST,
input				SW2,
input  [3:0]		ctr_sw,			
input				qk_ready,
output				qk1_valid,
output				qk2_valid,
output				qk3_valid,

output [7:0]		qk1_Error,
output [7:0]		qk2_Error,
output [7:0]		qk3_Error,

output [31:0] 		qk1_Asecret_key,
output [31:0] 		qk1_Bsecret_key,
output [31:0] 		qk2_Asecret_key,
output [31:0] 		qk2_Bsecret_key,
output [31:0] 		qk3_Asecret_key,
output [31:0] 		qk3_Bsecret_key
    );

    Quantum_Knight_1  zjw (
                .clk                ( CLK ),
                .rst                ( RST ),
                .ctr_sw             ( ctr_sw ),
                .AB2camera_ready    ( qk_ready ),
                .AB2camera_valid    ( qk1_valid ),
                // .Astate		        (qk1_Astate),
                // .Bstate             (qk1_Bstate),
                // .Bcount             (Bcount),
                .Error              ( qk1_Error ),
                .Asecret_key        ( qk1_Asecret_key) ,
                .Bsecret_key        ( qk1_Bsecret_key )
                // .ERROR_LED          ( ERROR_LED )
                //.test_random1       (test_random1),
                //.test_random2       (test_random2),
                //.test_d             (test_d),
                //.rand_result        (rand_result),
                //.test_temp_rand     (test_temp_rand),
                //.test_temp_randt	( test_temp_randt )
                );
    Quantum_Knight_2  hxy (
                .clk                ( CLK ),
                .rst                ( RST ),
                .SW2                ( SW2 ),
                .AB2camera_ready    ( qk_ready ),
                .AB2camera_valid    ( qk2_valid ),
                // .Astate		        ( qk2_Astate ),
                // .Bstate             ( qk2_Bstate ),
                // .Bcount             (Bcount),
                .Error              ( qk2_Error ),
                .Asecret_key        ( qk2_Asecret_key ),
                .Bsecret_key        ( qk2_Bsecret_key )
                // .ERROR_LED          ( ERROR_LED )
                //.test_random1       (test_random1),
                //.test_random2       (test_random2),
                //.test_d             (test_d),
                //.rand_result        (rand_result),
                //.test_temp_rand     (test_temp_rand),
                //.test_temp_randt	( test_temp_randt )
                );
    Quantum_Knight_3  wjy (
                .clk                ( CLK ),
                .rst                ( RST ),
                .SW2                ( SW2 ),
                .AB2camera_ready    ( qk_ready ),
                .AB2camera_valid    ( qk3_valid ),
                // .Astate		        ( qk2_Astate ),
                // .Bstate             ( qk2_Bstate ),
                // .Bcount             (Bcount),
                .Error              ( qk3_Error ),
                .Asecret_key        ( qk3_Asecret_key ),
                .Bsecret_key        ( qk3_Bsecret_key )
                // .ERROR_LED          ( ERROR_LED )
                //.test_random1       (test_random1),
                //.test_random2       (test_random2),
                //.test_d             (test_d),
                //.rand_result        (rand_result),
                //.test_temp_rand     (test_temp_rand),
                //.test_temp_randt	( test_temp_randt )
                );
endmodule
