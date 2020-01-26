module MARMUX_Unit(input logic [15:0] IR, Adder_Out,
	input MARMUX,
	output logic[15:0] MARMUX_Out);
	
	always_comb
	begin
	if(MARMUX)
		MARMUX_Out = Adder_Out;
	else
		MARMUX_Out = {8'b0, IR[7:0]};
	end
endmodule
