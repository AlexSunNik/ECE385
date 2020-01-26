module BEN_Unit(
input logic [15:0] IR, Bus,
input logic Clk, LD_BEN, LD_CC,
output logic BEN_Out);

logic [2:0] nzp_com, nzp_tran;
logic BEN_tran;
flipflop N(.Clk(Clk), .D_in(nzp_com[2]), .Load(LD_CC), .D_out(nzp_tran[2]));
flipflop Z(.Clk(Clk), .D_in(nzp_com[1]), .Load(LD_CC), .D_out(nzp_tran[1]));
flipflop P(.Clk(Clk), .D_in(nzp_com[0]), .Load(LD_CC), .D_out(nzp_tran[0]));
flipflop BEN(.Clk(Clk), .D_in(BEN_tran), .Load(LD_BEN), .D_out(BEN_Out));

always_comb
begin
	if(Bus[15])
		nzp_com = 3'b100;
	else
	begin
		if(!Bus)
			nzp_com = 3'b010;
		else
			nzp_com = 3'b001;
	end
	
	BEN_tran = (nzp_tran[2]&IR[11])|(nzp_tran[1]&IR[10])|(nzp_tran[0]&IR[9]);
end


endmodule

module flipflop(
input logic Clk, D_in, Load,
output logic D_out);
always_ff @ (posedge Clk)
begin
	if(Load)
		D_out <= D_in;
end
endmodule
