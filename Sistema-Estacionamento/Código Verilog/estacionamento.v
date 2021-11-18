module estacionamento (botao, led_verde, led_verm, motor);

input botao;
output reg led_verde;
output reg led_verm;
output reg motor;

always@(*) begin

	if(botao)begin
		led_verde = 1'b1;
		led_verm = 1'b0; 
		motor = 1'b0;
	end
	
	else begin
		led_verde = 1'b0;
		led_verm = 1'b1;
		motor = 1'b1;
	end
		
end 

endmodule 