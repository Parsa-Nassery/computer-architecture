`timescale 1 ns / 1 ns
module TEST();
	logic Clock = 1'd0,Reset = 1'd0;
	wire [31:0] MemOut;
	MipsProcessor MP(.myclk(Clock), .myrst(Reset), .myDataMemOut(MemOut));
	initial begin
		#100 Clock = 1'd0;
		for (int i = 0; i < 500; i++) begin
			#50 Clock = 1'd1;
			#50 Clock = 1'd0;
		end
		#100 $stop;
	end
endmodule