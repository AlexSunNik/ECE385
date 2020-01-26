module datapath(input logic GatePC, GateMDR, GateALU, GateMARMUX,
	input logic[15:0] MAR, PC, ALU, MDR,
	output logic[15:0] data_out);
	
	logic [3:0] MUX_Sel;
	assign MUX_Sel = {GatePC, GateMDR, GateALU, GateMARMUX};
	always_comb
	begin
		unique case(MUX_Sel)
			4'b1000: data_out = PC;
			4'b0100: data_out = MDR;
			4'b0010: data_out = ALU;
			4'b0001: data_out = MAR;
		endcase
	end

endmodule
