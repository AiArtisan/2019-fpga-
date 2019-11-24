/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "sleep.h"
#include "xil_io.h"
#include "oled.h"

int transc(int a)
{
	int b;
	switch(a){
	case 0:b=0;break;
	case 1:b=1;break;
	case 2:b=2;break;
	case 3:b=3;break;
	case 4:b=4;break;
	case 5:b=5;break;
	case 6:b=6;break;
	case 7:b=7;break;
	case 8:b=8;break;
	case 9:b=9;break;
	case 16:b=10;break;
	case 17:b=11;break;
	case 18:b=12;break;
	case 19:b=13;break;
	case 20:b=14;break;
	case 21:b=15;break;
	case 22:b=16;break;
	case 23:b=17;break;
	case 24:b=18;break;
	case 25:b=19;break;
	case 32:b=20;break;
	case 33:b=21;break;
	case 34:b=22;break;
	case 35:b=23;break;
	case 36:b=24;break;
	case 37:b=25;break;
	case 38:b=26;break;
	case 39:b=27;break;
	case 40:b=28;break;
	case 41:b=29;break;
	case 48:b=30;break;
	case 49:b=31;break;
	case 50:b=32;break;
	case 51:b=33;break;
	case 52:b=34;break;
	case 53:b=35;break;
	case 54:b=36;break;
	case 55:b=37;break;
	case 56:b=38;break;
	case 57:b=39;break;
	case 64:b=40;break;
	case 65:b=41;break;
	case 66:b=42;break;
	case 67:b=43;break;
	case 68:b=44;break;
	case 69:b=45;break;
	case 70:b=46;break;
	case 71:b=47;break;
	case 72:b=48;break;
	case 73:b=49;break;
	case 80:b=50;break;
	case 81:b=51;break;
	case 82:b=52;break;
	case 83:b=53;break;
	case 84:b=54;break;
	case 85:b=55;break;
	case 86:b=56;break;
	case 87:b=57;break;
	case 88:b=58;break;
	case 89:b=59;break;
	case 96:b=60;break;
	case 97:b=61;break;
	case 98:b=62;break;
	case 99:b=63;break;
	case 100:b=64;break;
	case 101:b=65;break;
	case 102:b=66;break;
	case 103:b=67;break;
	case 104:b=68;break;
	case 105:b=69;break;
	case 112:b=70;break;
	case 113:b=71;break;
	case 114:b=72;break;
	case 115:b=73;break;
	case 116:b=74;break;
	case 117:b=75;break;
	case 118:b=76;break;
	case 119:b=77;break;
	case 120:b=78;break;
	case 121:b=79;break;
	case 128:b=80;break;
	case 129:b=81;break;
	case 130:b=82;break;
	case 131:b=83;break;
	case 132:b=84;break;
	case 133:b=85;break;
	case 134:b=86;break;
	case 135:b=87;break;
	case 136:b=88;break;
	case 137:b=89;break;
	case 144:b=90;break;
	case 145:b=91;break;
	case 146:b=92;break;
	case 147:b=93;break;
	case 148:b=94;break;
	case 149:b=95;break;
	case 150:b=96;break;
	case 151:b=97;break;
	case 152:b=98;break;
	case 153:b=99;break;
	case 160:b=100;break;
	default:b=100;break;
	}
	return(b);
}


int main()
{
	int transc(int a);
	int Reg=83;
	char reg[8];
	int save;

	Reg=Xil_In32(0x41200000);
	save = Reg;
	while(1){
		Reg=Xil_In32(0x41200000);
		if(save != Reg)
		{
			save = Reg;
			Reg=transc(Reg);
			itoa(Reg,reg,10);
			OLED_Init();			//≥ı ºªØ“∫æß
			OLED_ShowString(0,16, "         ");
			OLED_ShowString(0,16, reg);
			OLED_ShowString(24,16, "%");
			OLED_ShowString(0,0, "Error rate");

			OLED_Refresh_Gram();
		}

//		sleep(1);

	}
	//	init_platform();
//    print("Hello World\n\r");
//
//    cleanup_platform();
    return 0;
}
