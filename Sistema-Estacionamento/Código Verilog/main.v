module main (

input CL,CL2,
input S1, S2, S3, S4, S5, S6,
input clock, 
input force_reset,
input iRST,
input state, 
input res,
						
output MotorS,MotorE,
output LED_V, LED_R, LED_V2, LED_R2, 
output LG1, LG2, LG3, LG4, LG5, LG6,
output LR1, LR2, LR3, LR4, LR5, LR6, 
output reset,
output DATA,
output RW,
output EN,
output RS
			  );

	estacionamento inst( .botao(CL),
								.motor(MotorS),
								.led_verde(LED_V),
								.led_verm(LED_R)
							  );
							  
	estacionamento inst10( .botao(CL2),
								.motor(MotorE),
								.led_verde(LED_V2),
								.led_verm(LED_R2)
							  );					  
							  
							  
	vaga inst2( .sensor(S1),
					.led_green(LG1),
					.led_red(LR1),
					//.reset(res)
				 		);
						
	vaga inst3( .sensor(S2),
					.led_green(LG2),
					.led_red(LR2), 
					//.reset(res)
					
				 		);
						
   vaga inst4( .sensor(S3),
					.led_green(LG3),
					.led_red(LR3),
					//.reset(res)
					
				 		);
	
	vaga inst5( .sensor(S4),
					.led_green(LG4),
					.led_red(LR4),
					//.reset(res)
					
				 		);
						
	vaga inst6( .sensor(S5),
					.led_green(LG5),
					.led_red(LR5),
					//.reset(res)
					
				 		);
						
	vaga inst7( .sensor(S6),
					.led_green(LG6),
					.led_red(LR6),
					//.reset(res)
					
				 		);	
				
	LCD_Reset_Delay inst8 ( .iCLK(clock),
									.FORCE_RESET(force_reset),
									.oRESET(reset)
	
									);		
									
	LCD_CONTENT inst9 (.iCLK(clock),
					.iRST_N(iRST),
					.week_state(state),
					.LCD_DATA(DATA),
					.LCD_RW(RW),
					.LCD_EN(EN),
					.LCD_RS(RS),
					.reset(res)
					
						);
	
endmodule 