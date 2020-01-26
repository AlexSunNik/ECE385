module LookAheadUnit(
	input[3:0] p,g,
	input c_in,
	output[2:0] C,
	output c_out,
	output PG,GG);
	
	always_comb
	begin
	//Carry-out for each bits
	C[0] = (c_in&p[0])|g[0];
	C[1] = (c_in&p[0]&p[1]) | (g[0]&p[1]) | g[1];
	C[2] = (c_in&p[0]&p[1]&p[2]) | (g[0]&p[1]&p[2]) | (g[1]&p[2]) | g[2];
	c_out = (c_in&p[0]&p[1]&p[2]&p[3]) | (g[0]&p[1]&p[2]&p[3]) | (g[1]&p[2]&p[3]) | (g[2]&p[3]) | g[3];
	//Overall P and G of the entire adder unit
	PG = p[0]&p[1]&p[2]&p[3];
	GG = g[3]|(g[2]&p[3])|(g[1]&p[3]&p[2])|(g[0]&p[3]&p[2]&p[1]);
	end
endmodule
