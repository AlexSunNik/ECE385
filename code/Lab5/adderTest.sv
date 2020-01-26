module adderTest();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic [8:0] A,B;
logic c_in, Add, Sub, M_in;

// To store expected results
logic [8:0] ans, S;
logic c_out;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
AdderUnit AU0(.*);	

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
#1 A = {0,8'h09};
#1 B = {0,8'h04};
#1 Add = 1'b0;
#1 Sub = 1'b1;
#1 c_in = 1'b0;
#1 M_in = 1'b0;
#1 ans = {0, 8'h5};
// Aval and Bval are expected to swap
#20 if (S != ans)
	 ErrorCnt++;


if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
