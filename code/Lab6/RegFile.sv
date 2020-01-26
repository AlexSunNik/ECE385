module RegFile(input logic [15:0] IR, D_in,
input logic [1:0] DRMUX, SR1MUX,
input logic LD_REG, Clk, Reset,
output logic [15:0] SR1_Out, SR2_Out
);

logic[2:0] DR,SR1,SR2;
logic[7:0] l;
logic[15:0] D0, D1, D2, D3, D4, D5, D6, D7;

reg_16 Reg0(.Clk(Clk), .Reset(Reset), .Load(l[0]), .D(D_in),.Data_Out(D0));
reg_16 Reg1(.Clk(Clk), .Reset(Reset), .Load(l[1]), .D(D_in),.Data_Out(D1));
reg_16 Reg2(.Clk(Clk), .Reset(Reset), .Load(l[2]), .D(D_in),.Data_Out(D2));
reg_16 Reg3(.Clk(Clk), .Reset(Reset), .Load(l[3]), .D(D_in),.Data_Out(D3));
reg_16 Reg4(.Clk(Clk), .Reset(Reset), .Load(l[4]), .D(D_in),.Data_Out(D4));
reg_16 Reg5(.Clk(Clk), .Reset(Reset), .Load(l[5]), .D(D_in),.Data_Out(D5));
reg_16 Reg6(.Clk(Clk), .Reset(Reset), .Load(l[6]), .D(D_in),.Data_Out(D6));
reg_16 Reg7(.Clk(Clk), .Reset(Reset), .Load(l[7]), .D(D_in),.Data_Out(D7));

always_comb
begin
	unique case(DRMUX)
		2'b00: DR = IR[11:9];
		2'b01: DR = 3'b111;
		2'b10: DR = 3'b110;
	endcase
	unique case(SR1MUX)
		2'b00: SR1 = IR[11:9];
		2'b01: SR1 = IR[8:6];
		2'b10: SR1 = 3'b110;
	endcase
	SR2 = IR[2:0];
	if(LD_REG)
	begin
		unique case(DR)
		3'b000: l = 8'h01;
		3'b001: l = 8'h02;
		3'b010: l = 8'h04;
		3'b011: l = 8'h08;
		3'b100: l = 8'h10;
		3'b101: l = 8'h20;
		3'b110: l = 8'h40;
		3'b111: l = 8'h80;
	endcase
	end
	else
		l = 8'h00;
	unique case(SR1)
		3'b000: SR1_Out = D0;
		3'b001: SR1_Out = D1;
		3'b010: SR1_Out = D2;
		3'b011: SR1_Out = D3;
		3'b100: SR1_Out = D4;
		3'b101: SR1_Out = D5;
		3'b110: SR1_Out = D6;
		3'b111: SR1_Out = D7;
	endcase
	unique case(SR2)
		3'b000: SR2_Out = D0;
		3'b001: SR2_Out = D1;
		3'b010: SR2_Out = D2;
		3'b011: SR2_Out = D3;
		3'b100: SR2_Out = D4;
		3'b101: SR2_Out = D5;
		3'b110: SR2_Out = D6;
		3'b111: SR2_Out = D7;
	endcase
end

endmodule
