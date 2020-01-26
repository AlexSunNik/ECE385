module testPart2();


timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;
				
// A counter to count the instances where simulation results
// do no match with expected results
//integer ErrorCnt = 0;


logic [15:0] S;
logic Clk, Reset, Run, Continue;
logic [11:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
logic CE, UB, LB, OE, WE;
logic [19:0] ADDR;
wire [15:0] Data;

// Instantiating the DUT
// Make sure the module and signal names match with those in your design
lab6_toplevel top(.*);	

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
Reset = 0;		// Toggle Rest
Run = 1;
Continue = 1;
S = 16'h0031;
#3 Reset = 1;

#5 Run = 0;
#5 Run = 1;

#240 S = 16'h0004;
#2 Continue = 0;
#2 Continue = 1;
#120 S = 16'h0005;
#2 Continue = 0;
#2 Continue = 1;


// Aval and Bval are expected to swap
/*#100 if ({Aval,Bval} != ans)
	 ErrorCnt++;*/

/*
if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);*/
	
end
endmodule
