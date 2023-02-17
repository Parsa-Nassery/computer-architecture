
module ErrorChecker(input clk, rst, en_err, input [19:0] xi, yi, input [19:0] b0, b1, output [19:0] err);
	reg [83:0] reg_err;
	always @(posedge clk, posedge rst) begin
		if(rst)
			reg_err <= 84'b0;
		else begin
			if(en_err)
				reg_err <= yi - b0 - ((b1 * xi) >> 10);
		end
	end
	assign err = reg_err[19:0];
endmodule
