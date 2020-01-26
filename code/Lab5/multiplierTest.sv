module multiplierTest();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;

logic Clk, Reset, Run, ClearA_LoadB;
logic[7:0] S;
logic[7:0] Aval,Bval;
logic X, M_out,Op_out;
logic [6:0] AhexL,
		 AhexU,
		 BhexL,
		 BhexU; 
logic[15:0] ans;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
Multiplier MT0(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 1;		// Toggle Rest
Run = 1;
ClearA_LoadB = 1;
S = 8'b0;
#2 Reset = 0;
#2 Reset = 1;
#2 S = 8'hFB;
#2 ClearA_LoadB = 0;
#4 ClearA_LoadB = 1;
#6 S = 8'hFC;
#2 ans = 16'h14;

#2 Run = 0;
#2 Run = 1;

// Aval and Bval are expected to swap
#100 if ({Aval,Bval} != ans)
	 ErrorCnt++;


if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
