module bitsFullAdder (input logic c_in,
	input logic[8:0] A,B,
	output logic [8:0] S,
	output logic c_out);
	
	logic ci1, ci2, ci3, ci4, ci5, ci6, ci7, ci8;
	fulladder fa0 (.a(A[0]), .b(B[0]), .c_in(c_in), .s(S[0]), .c_out(ci1));
	fulladder fa1 (.a(A[1]), .b(B[1]), .c_in(ci1), .s(S[1]), .c_out(ci2));
	fulladder fa2 (.a(A[2]), .b(B[2]), .c_in(ci2), .s(S[2]), .c_out(ci3));
	fulladder fa3 (.a(A[3]), .b(B[3]), .c_in(ci3), .s(S[3]), .c_out(ci4));
	fulladder fa4 (.a(A[4]), .b(B[4]), .c_in(ci4), .s(S[4]), .c_out(ci5));
	fulladder fa5 (.a(A[5]), .b(B[5]), .c_in(ci5), .s(S[5]), .c_out(ci6));
	fulladder fa6 (.a(A[6]), .b(B[6]), .c_in(ci6), .s(S[6]), .c_out(ci7));
	fulladder fa7 (.a(A[7]), .b(B[7]), .c_in(ci7), .s(S[7]), .c_out(ci8));
	fulladder fa8 (.a(A[8]), .b(B[8]), .c_in(ci8), .s(S[8]), .c_out(c_out));

endmodule

module fulladder(input logic a, b, c_in,
output logic s, c_out);

assign s = a^b^c_in;
assign c_out = (a&b) | (a&c_in) | (b&c_in);

endmodule
