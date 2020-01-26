module counter(input logic Clk, Reset, Ctr_En,
	output logic [3:0] Ctr_Out);
	
	enum logic [3:0] {A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P} curr_state, next_state;
	
	always_ff @(posedge Clk)
		begin
			if(Reset)
				curr_state <= A;
			else
				curr_state <= next_state;
		end
	
	always_comb
		begin
			next_state = curr_state;
			
			unique case (curr_state)
				A: if(Ctr_En)
					next_state = B;
				B: next_state = C;
				C: next_state = D;
				D: next_state = E;
				E: next_state = F;
				F: next_state = G;
				G: next_state = H;
				H: next_state = I;
				I: next_state = J;
				J: next_state = K;
				K: next_state = L;
				L: next_state = M;
				M: next_state = N;
				N: next_state = O;
				O: next_state = P;
				P: next_state = A;
			endcase
		end
endmodule
