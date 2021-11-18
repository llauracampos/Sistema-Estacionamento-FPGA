/* Modulo alterado para receber um novo sinal de entrada (week_state), o qual representa um dos sete dias da semana. A mensagem a ser
 * apresentada no LCD depende do valor dessa entrada */

module	LCD_CONTENT (	//	Host Side
					iCLK,iRST_N, week_state, reset,
					//	LCD Side
					LCD_DATA,LCD_RW,LCD_EN,LCD_RS	);
//	Host Side
input			iCLK,iRST_N, reset;

input       [2:0] week_state;  //Nova entrada para representar um dia da semana
//	LCD Side
output	[7:0]	LCD_DATA;
output			LCD_RW,LCD_EN,LCD_RS;
//	Internal Wires/Registers
reg	[5:0]	LUT_INDEX;
reg	[8:0]	LUT_DATA;
reg	[5:0]	mLCD_ST;
reg	[17:0]	mDLY;
reg			mLCD_Start;
reg	[7:0]	mLCD_DATA;
reg			mLCD_RS;
wire		mLCD_Done;

parameter	LCD_INTIAL	=	0;
parameter	LCD_LINE1	=	5;
parameter	LCD_CH_LINE	=	LCD_LINE1+16;
parameter	LCD_LINE2	=	LCD_LINE1+16+1;
parameter	LUT_SIZE	=	LCD_LINE1+32+1;

always@(posedge iCLK or negedge iRST_N or posedge reset)
begin
	if(!iRST_N || reset)
	begin
		LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
		if(LUT_INDEX < LUT_SIZE)
		begin
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mLCD_ST	<=	0;
				end
			endcase
		end
	end
end

/*
-------------------------------------------------------------------
--                        ASCII HEX TABLE
--  Hex                        Low Hex Digit
-- Value  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
------\----------------------------------------------------------------
--H  2 |  SP  !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /
--i  3 |  0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
--g  4 |  @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
--h  5 |  P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _
--   6 |  `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o
--   7 |  p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~ DEL
-----------------------------------------------------------------------
-- Example "A" is row 4 column 1, so hex value is 8'h41"
-- *see LCD Controller's Datasheet for other graphics characters available
*/

always@(posedge iCLK) //ADICIONEI AQUI CLOCK NA LISTA DE SENSIBILIDADE - ANTES NAO TINHA LISTA DE SENSIBILIDADE
begin
	case(LUT_INDEX) //Esses primeiros caracteres de controle devem ser enviados para o LCD, independentemente do que vai ser efetivamente
	                //impresso na tela
		//	Initial
		LCD_INTIAL+0:	LUT_DATA	<=	9'h038;
		LCD_INTIAL+1:	LUT_DATA	<=	9'h00C;
		LCD_INTIAL+2:	LUT_DATA	<=	9'h001;
		LCD_INTIAL+3:	LUT_DATA	<=	9'h006;
		LCD_INTIAL+4:	LUT_DATA	<=	9'h080;
	endcase
	
   case(week_state) //Case para definir a mensagem a ser exibida dependendo do valor de week_state
		0: case(LUT_INDEX)
			//	Line 1
			LCD_LINE1+0:	LUT_DATA	<=	9'h144;	// D
			LCD_LINE1+1:	LUT_DATA	<=	9'h16F; // o
			LCD_LINE1+2:	LUT_DATA	<=	9'h16D; // m
			LCD_LINE1+3:	LUT_DATA	<=	9'h169; // i
			LCD_LINE1+4:	LUT_DATA	<=	9'h16E; // n
			LCD_LINE1+5:	LUT_DATA	<=	9'h167; // g
			LCD_LINE1+6:	LUT_DATA	<=	9'h16F; // o
			LCD_LINE1+7:	LUT_DATA	<=	9'h120; // SP
		endcase
		
		1: case(LUT_INDEX)	
			//	Line 1
			LCD_LINE1+0:	LUT_DATA	<=	9'h153;	// S
			LCD_LINE1+1:	LUT_DATA	<=	9'h165; // e
			LCD_LINE1+2:	LUT_DATA	<=	9'h167; // g
			LCD_LINE1+3:	LUT_DATA	<=	9'h175; // u
			LCD_LINE1+4:	LUT_DATA	<=	9'h16E; // n
			LCD_LINE1+5:	LUT_DATA	<=	9'h164; // d
			LCD_LINE1+6:	LUT_DATA	<=	9'h161; // a
			LCD_LINE1+7:	LUT_DATA	<=	9'h120; // SP	
		endcase
		
		2: case(LUT_INDEX)	
			//	Line 1
			LCD_LINE1+0:	LUT_DATA	<=	9'h154;	// T
			LCD_LINE1+1:	LUT_DATA	<=	9'h165; // e
			LCD_LINE1+2:	LUT_DATA	<=	9'h172; // r
			LCD_LINE1+3:	LUT_DATA	<=	9'h163; // c
			LCD_LINE1+4:	LUT_DATA	<=	9'h161; // a
			LCD_LINE1+5:	LUT_DATA	<=	9'h120; // SP				
		endcase
		
		3: case(LUT_INDEX)	
			//	Line 1
			LCD_LINE1+0:	LUT_DATA	<=	9'h151;	// Q
			LCD_LINE1+1:	LUT_DATA	<=	9'h175; // u
			LCD_LINE1+2:	LUT_DATA	<=	9'h161; // a
			LCD_LINE1+3:	LUT_DATA	<=	9'h172; // r
			LCD_LINE1+4:	LUT_DATA	<=	9'h174; // t
			LCD_LINE1+5:	LUT_DATA	<=	9'h161; // a
			LCD_LINE1+6:	LUT_DATA	<=	9'h120; // SP				
		endcase
		
		4: case(LUT_INDEX)	
			//	Line 1
			LCD_LINE1+0:	LUT_DATA	<=	9'h151;	// Q
			LCD_LINE1+1:	LUT_DATA	<=	9'h175; // u
			LCD_LINE1+2:	LUT_DATA	<=	9'h169; // i
			LCD_LINE1+3:	LUT_DATA	<=	9'h16E; // n
			LCD_LINE1+4:	LUT_DATA	<=	9'h174; // t
			LCD_LINE1+5:	LUT_DATA	<=	9'h161; // a
			LCD_LINE1+6:	LUT_DATA	<=	9'h120; // SP				
		endcase
		
		5: case(LUT_INDEX)	
			//	Line 1
			LCD_LINE1+0:	LUT_DATA	<=	9'h153;	// S
			LCD_LINE1+1:	LUT_DATA	<=	9'h165; // e
			LCD_LINE1+2:	LUT_DATA	<=	9'h178; // x
			LCD_LINE1+3:	LUT_DATA	<=	9'h174; // t
			LCD_LINE1+4:	LUT_DATA	<=	9'h161; // a
			LCD_LINE1+5:	LUT_DATA	<=	9'h120; // SP				
		endcase
		
		6: case(LUT_INDEX)	
			//	Line 1
			LCD_LINE1+0:	LUT_DATA	<=	9'h153;	// S
			LCD_LINE1+1:	LUT_DATA	<=	9'h161; // a
			LCD_LINE1+2:	LUT_DATA	<=	9'h162; // b
			LCD_LINE1+3:	LUT_DATA	<=	9'h161; // a
			LCD_LINE1+4:	LUT_DATA	<=	9'h164; // d
			LCD_LINE1+5:	LUT_DATA	<=	9'h16F; // o
			LCD_LINE1+6:	LUT_DATA	<=	9'h120; // SP				
		endcase
		
	endcase
end

LCD_Controller 		u0	(	//	Host Side
							.iDATA(mLCD_DATA),
							.iRS(mLCD_RS),
							.iStart(mLCD_Start),
							.oDone(mLCD_Done),
							.iCLK(iCLK),
							.iRST_N(iRST_N),
							//	LCD Interface
							.LCD_DATA(LCD_DATA),
							.LCD_RW(LCD_RW),
							.LCD_EN(LCD_EN),
							.LCD_RS(LCD_RS),
							.reset(reset)
							);

endmodule
