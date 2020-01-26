module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

	  logic c4,c8,c12;  //Interal carry-out logic
     CRAadder CRA0 (.A(A[3:0]), .B(B[3:0]), .Z(1'b0), .S(Sum[3:0]), .C(c4));  //The first 4-bit CRA adder
	  CSAadder CSA1 (.A(A[7:4]), .B(B[7:4]), .c_in(c4), .S(Sum[7:4]), .c_out(c8));  //4-bit CSA adder for [15:4]
	  CSAadder CSA2 (.A(A[11:8]), .B(B[11:8]), .c_in(c8), .S(Sum[11:8]), .c_out(c12));
	  CSAadder CSA3 (.A(A[15:12]), .B(B[15:12]), .c_in(c12), .S(Sum[15:12]), .c_out(CO));
endmodule
