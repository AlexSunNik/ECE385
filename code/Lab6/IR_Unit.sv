module IR_Unit(input logic LD_IR, Clk,
	input logic[15:0] IR_In,
	output logic[15:0] IR_Out);
	
	reg_16 IR_Reg(.Clk(Clk), .Reset(), .Load(LD_IR), .D(IR_In), .Data_Out(IR_Out));

endmodule