module ALUUnit(input logic [15:0] A,B0,IR,
input logic [1:0] ALUK,
output logic [15:0] ALU_Out);

logic [15:0] B_in;

always_comb
begin
	if(IR[5])
		B_in = {{11{IR[4]}}, IR[4:0]};
	else
		B_in = B0;
	unique case(ALUK)
		2'b00: ALU_Out = A + B_in;
		2'b01: ALU_Out = A & B_in;
		2'b10: ALU_Out = ~A;
		2'b11: ALU_Out = A;
	endcase
end
endmodule
