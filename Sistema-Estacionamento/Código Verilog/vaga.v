module vaga (sensor, led_green, led_red);

input sensor;
output reg led_green;
output reg led_red;

reg[2:0] contador = 3'b000;
 
always@(*) begin
	//reset = 0;
	if(~sensor)begin
	//	reset = 1;
		led_green = 1'b1;
		led_red = 1'b0; 
		if(contador > 3'b000) begin
			contador = contador - 1; end
	end
	else begin
		led_green = 1'b0;
		led_red = 1'b1;
		if(contador < 3'b110) begin
			contador = contador + 1; end
	end
		
end 
endmodule 