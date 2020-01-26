module AdderUnit(input logic c_in, Add, Sub, M_in,
	input logic[8:0] A,B,
	output logic [8:0] S,
	output logic c_out);
	
	logic [8:0] B_Buf, B_Neg;
	bitsFullAdder bf0(.c_in(1'b0), .A(A), .B(B_Buf), .S(S), .c_out(c_out));
	bitsFullAdder bf1(.c_in(1'b1), .A(~B), .B(9'b0), .S(B_Neg), .c_out());
	
	always_comb
		begin
		
			if(M_in)
				begin
				if(Add)
					B_Buf = B;
				else
					B_Buf = B_Neg;
				end
			else
				B_Buf = 8'b0;
		end
	
endmodule
