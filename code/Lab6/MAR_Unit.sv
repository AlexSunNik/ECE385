module MAR_Unit(input logic LD_MAR, Clk,
	input logic[15:0] MAR_In,
	output logic[15:0] MAR_Out);
	
	reg_16 MAR_Reg(.Clk(Clk), .Reset(), .Load(LD_MAR), .D(MAR_In), .Data_Out(MAR_Out));

endmodule
