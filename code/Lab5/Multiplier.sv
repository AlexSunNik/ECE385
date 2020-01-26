module Multiplier(input logic Clk, Reset, Run, ClearA_LoadB,
	input logic[7:0] S,
	output logic[7:0] Aval,Bval,
	output logic X,M_out,Op_out,
	output logic [6:0]  AhexL,AhexU,BhexL,BhexU);
	
	logic controlAdd, controlSub, controlOp, controlCL, controlXA, controlShift,tranM;
	logic [7:0] tranA_out;
	logic [8:0] tranRes;
	assign M_out = tranM;
	assign Op_out = controlOp;

	AdderUnit AU1(.c_in(1'b0), .Add(controlAdd), .Sub(controlSub),.M_in(tranM),.B({S[7],S}),.A({tranA_out[7],tranA_out}),.S(tranRes),.c_out());
	ControlUnit CU1(.Reset(!Reset), .Clk(Clk), .Run(!Run), .M(tranM), .LoadClear(!ClearA_LoadB),.Shift(controlShift),.Add(controlAdd),.Sub(controlSub),.Op(controlOp),.Clr_Ld(controlCL), .Clr_XA(controlXA));
	RegUnit RU1(.Shift(controlShift), .Clr_Ld(controlCL), .Clr_XA(controlXA), .Clk(Clk), .X(tranRes[8]), .Op(controlOp),.A(tranRes[7:0]), .B(S),.S({Aval, Bval}),.A_out(tranA_out),.M(tranM), .X_out(X));

	HexDriver        HexAL(
                        .In0(Aval[3:0]),
                        .Out0(AhexL) );
	 HexDriver        HexBL (
                        .In0(Bval[3:0]),
                        .Out0(BhexL) );
								
	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	 HexDriver        HexAU (
                        .In0(Aval[7:4]),
                        .Out0(AhexU) );	
	 HexDriver        HexBU (
                       .In0(Bval[7:4]),
                        .Out0(BhexU) );
								
	endmodule
