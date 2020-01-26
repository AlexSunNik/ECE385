module Addr_Adder (input logic[15:0] IR, SR1_In, PC_In,
input logic [1:0] ADDR2MUX,
input logic ADDR1MUX,
output logic [15:0] Addr_AdderOut);

logic [15:0] sext1, sext2, sext3, adder1, adder2;
always_comb
begin
	sext1 = {{10{IR[5]}}, IR[5:0]};
	sext2 = {{7{IR[8]}},IR[8:0]};
	sext3 = {{5{IR[10]}}, IR[10:0]};
	
	unique case (ADDR2MUX)
		2'b00: adder1 = 16'h0000;
		2'b01: adder1 = sext1;
		2'b10: adder1 = sext2;
		2'b11: adder1 = sext3;
	endcase

	if(ADDR1MUX)
		adder2 = SR1_In;
	else
		adder2 = PC_In;
	
	Addr_AdderOut = adder1 + adder2;
end
endmodule
