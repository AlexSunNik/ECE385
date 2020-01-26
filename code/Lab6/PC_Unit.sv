module PC_Unit(input logic Ld_PC, Clk, Reset,
	input logic[1:0] PC_Sel,
	input logic[15:0] PC_Bus, PC_Adr,
	output logic[15:0] PC_Out);
	
	logic [15:0] PC_Next;
	reg_16 PCReg(.Clk(Clk), .Reset(Reset), .Load(Ld_PC), .D(PC_Next),.Data_Out(PC_Out));
	
	always_comb
	begin
		unique case(PC_Sel)
			2'b00:
				PC_Next = PC_Out + 1;
			2'b01:
				PC_Next = PC_Bus;
			2'b10:
				PC_Next = PC_Adr;
			default:
				PC_Next = PC_Out;
		endcase
	end
endmodule
