module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

	  logic p0,g0,p4,g4,p8,g8,p12,g12;  //Logic Ps and Gs
	  logic	c4,c8,c12;  //Internal carry-out logic
	  
	  CLAadder CLA0 (.A(A[3:0]),.B(B[3:0]),.c_in(1'b0),.s_out(Sum[3:0]), .p(p0), .g(g0), .c_out());  //4-bit CLA adder
	  CLAadder CLA1 (.A(A[7:4]),.B(B[7:4]),.c_in(c4),.s_out(Sum[7:4]), .p(p4), .g(g4), .c_out());
	  CLAadder CLA2 (.A(A[11:8]),.B(B[11:8]),.c_in(c8),.s_out(Sum[11:8]), .p(p8), .g(g8), .c_out());
	  CLAadder CLA3 (.A(A[15:12]),.B(B[15:12]),.c_in(c12),.s_out(Sum[15:12]), .p(p12), .g(g12), .c_out());
	  LookAheadUnit LAUnit (.p({p12,p8,p4,p0}), .g({g12,g8,g4,g0}), .c_in(1'b0), .C({c12,c8,c4}), .c_out(CO), .PG(), .GG());  //The overall lookahead unit for the entire adder
		
	
endmodule
