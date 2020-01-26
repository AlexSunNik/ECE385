module CLAadder (
input [3:0]A,B, 
input c_in,
output logic [3:0]s_out,
output logic p,g,
output logic c_out
);

logic c1, c2, c3;
logic p0,p1,p2,p3,g0,g1,g2,g3;

always_comb
begin
//Logic for Ps and Gs
p0 = A[0]^B[0];
p1 = A[1]^B[1];
p2 = A[2]^B[2];
p3 = A[3]^B[3];

g0 = A[0]&B[0];
g1 = A[1]&B[1];
g2 = A[2]&B[2];
g3 = A[3]&B[3];
end

full_adder FA0(.x(A[0]),.y(B[0]),.z(c_in), .s(s_out[0]), .c());
full_adder FA1(.x(A[1]),.y(B[1]),.z(c1), .s(s_out[1]), .c());
full_adder FA2(.x(A[2]),.y(B[2]),.z(c2), .s(s_out[2]), .c());
full_adder FA3(.x(A[3]),.y(B[3]),.z(c3), .s(s_out[3]), .c());
//LookAheadUnit inside a 4-bit CLA
LookAheadUnit LAUnit(.p({p3,p2,p1,p0}),.g({g3,g2,g1,g0}),.c_in(c_in),.C({c3,c2,c1}), .c_out(), .PG(p), .GG(g));

endmodule

