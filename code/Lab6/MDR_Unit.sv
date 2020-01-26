module MDR_Unit(input logic MIO_EN, LD_MDR, Clk, 
	input logic [15:0] MD_Bus, MD_Mem,
	output logic [15:0] MDR_Out);
	
	logic[15:0] D_Trans;
	reg_16 MDR_Reg(.Clk(Clk), .Reset(), .Load(LD_MDR), .D(D_Trans), .Data_Out(MDR_Out));
	
	always_comb
	begin
		if(MIO_EN)
			D_Trans = MD_Mem;
		else
			D_Trans = MD_Bus;
	end

endmodule
