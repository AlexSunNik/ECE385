module CSAadder(
	input[3:0] A,B,
	input c_in,
	output logic[3:0] S,
	output logic c_out);
	
	logic[3:0] s_1,s_0;
	logic c_1,c_0;
	//CSA adder contains to CRA module, one with carry in 0 another is 1
	CRAadder CRA0(.A(A), .B(B), .Z(1'b0), .S(s_0), .C(c_0));
	CRAadder CRA1(.A(A), .B(B), .Z(1'b1), .S(s_1), .C(c_1));
	
	always_comb
	begin
	//MUX to choose the result
		case(c_in)
			1'b0: S = s_0;
			1'b1: S = s_1;
		endcase
	c_out = (c_1 & c_in) | c_0;
	end
endmodule
