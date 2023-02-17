`timescale 1 ns / 1 ns
module TEST();
	logic Clock = 1'd0,Reset = 1'd0, Start = 1'd0;
	wire [19:0] Vect_Err;
	wire Ready;
	LinearRegressor LR1(.clk(Clock), .rst(Reset), .start(Start), .Vect_E(Vect_Err), .ready(Ready));
	initial begin
		#50 Clock = 1'd0;
		#50 Clock = 1'd1;
		#50 Clock = 1'd0;
		#50 Start = 1'd1;
		#50 Clock = 1'd1;
		#50 Clock = 1'd0;
		#50 Start = 1'd0;
		for (int i = 0; i < 400; i++) begin
			#50 Clock = 1'd1;
			#50 Clock = 1'd0;
		end
		#100 $stop;
	end
endmodule