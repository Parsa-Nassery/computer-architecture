`timescale 1 ns / 1 ns
module TEST();
	logic Clock = 1'd0, Reset = 1'd0;
	wire [15:0] MemOut;
	Processor MP(.clk(Clock), .rst(Reset), .DataMemOut(MemOut));
	initial begin
		#100 Clock = 1'd0;
		for (int i = 0; i < 1000; i++) begin
			#50 Clock = 1'd1;
			#50 Clock = 1'd0;
		end
		#100 $stop;
	end
endmodule