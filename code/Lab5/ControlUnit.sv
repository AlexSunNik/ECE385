module ControlUnit(
input logic Reset, Clk, Run, M, LoadClear,
output logic Shift, Add, Sub, Op,Clr_Ld, Clr_XA);

enum logic [4:0] {A,B,C,D,E,F,G,H,I,J,K,L,MM,N,O,P,Q,R,Ini,Hold,Bready, Halt} curr_state, next_state;

assign Op = Add | Sub;

always_ff @ (posedge Clk)
	begin
		if(Reset)
			curr_state <= Ini;
		else
			curr_state <= next_state;
	end

always_comb
	begin
		next_state = curr_state;
		
		unique case (curr_state)
			Ini:
			begin
			if(LoadClear)
				next_state = A;
			end
			A: next_state = Bready;
			Bready: 
			begin
			if(Run)
				next_state = B;
			end
			B: next_state = C;
			C: next_state = D;
			D: next_state = E;
			E:	next_state = F;
			F: next_state = G;
			G: next_state = H;
			H: next_state = I;
			I: next_state = J;
			J: next_state = K;
			K: next_state = L;
			L: next_state = MM;
			MM: next_state = N;
			N: next_state = O;
			O: next_state = P;
			P: next_state = Q;
			Q: next_state = Halt;
			R: next_state = B;
			Halt:
				if(!Run)
					next_state = Hold;
			Hold:
			begin
				if(Run)
					next_state = R;
			end
		endcase
	end
	
always_comb
	begin
		case(curr_state)
			Ini:
				begin
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			A:
				begin
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b1;
					Clr_XA = 1'b0;
				end
			Bready:
				begin
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			B:
				begin
					Shift = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			C:
				begin
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			D:
				begin
					Shift = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			E:
				begin
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			F:
				begin
					Shift = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			G:
				begin
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			H:
				begin
					Shift = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			I:
				begin
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			J:
				begin
					Shift = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			K:
				begin
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			L:
				begin
					Shift = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			MM:
				begin
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			N:
				begin
					Shift = 1'b0;
					Add = 1'b1;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			O:
				begin
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			P:
				begin
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b1;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			Q:
				begin
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			R:
				begin
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b1;
				end
			Hold:
				begin
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			Halt:
				begin
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			default:
				begin
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					Clr_Ld = 1'b0;
					Clr_XA = 1'b0;
				end
			endcase
				
	end

endmodule
