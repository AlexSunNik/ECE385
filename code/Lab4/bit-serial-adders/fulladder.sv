module full_adder (input x,y,z,
	output logic s,c);
	
	//Single bit full adder
	assign s = x^y^z;
	assign c = (x&y)|(y&z)|(x&z);
	
endmodule