
module CoCalculator(input clk, rst, en_x, en_y, en_xx, en_xy, en_x2, en_x_y, en_b0, en_b1, input [19:0] xi, yi, input [15:0] m, output [83:0] b0, output [55:0] b1);
	reg [27:0] reg_x = 28'b0;
	reg [27:0] reg_y = 28'b0;
	reg [55:0] reg_xx = 56'b0;
	reg [55:0] reg_x2 = 56'b0;
	reg [55:0] reg_x_y = 56'b0;
	reg [55:0] reg_xy = 56'b0;
	reg [55:0] reg_b1 = 56'b0;
	reg [83:0] reg_b0 = 84'b0;

	always @(posedge clk, posedge rst) begin
		if(rst) begin
			reg_x <= 28'b0;
			reg_y <= 28'b0;
			reg_xx <= 56'b0;
			reg_x2 <= 56'b0;
			reg_x_y <= 56'b0;
			reg_xy <= 56'b0;
			reg_b1 <= 56'b0;
			reg_b0 <= 84'b0;
		end
		else begin
			if(en_x)
				reg_x <= reg_x + {8'b0,xi};
			if(en_y)
				reg_y <= reg_y + {8'b0,yi};
			if(en_xx) begin
				if(m[10]) begin
					if(m[4])
						reg_xx <= reg_xx + (xi * xi);
					else 
						reg_xx <= reg_xx + (reg_x * reg_x);
				end
				else
					reg_xx <= reg_xx - reg_x2;
			end
			if(en_xy) begin
				if(m[8]) begin
					if(m[2] && m[3] == 1'b0)
						reg_xy <= reg_xy + (xi * yi);
				end
				else
					reg_xy <= reg_xy - reg_x_y;
			end
			if(en_x2) begin
				if(m[9])
					reg_x2 <= reg_x * reg_x;
				else
					reg_x2 <= reg_x2 / 8'b10010110;
			end
			if(en_x_y) begin
				if(m[7])
					reg_x_y <= reg_x * reg_y;
				else
					reg_x_y <= reg_x_y / 8'b10010110;
			end
			if(en_b1)
				reg_b1 <= (reg_xy << 10) / reg_xx;
			if(en_b0) begin
				if(m[11]) begin
					if(m[6])
						reg_b0 <= reg_b1 * reg_x;
					else
						reg_b0 <= reg_b0 / 8'b10010110;
				end
				else
					reg_b0 <= reg_y - (reg_b0 >> 10);
			end
		end
	end
	
	assign b0 = reg_b0;
	assign b1 = reg_b1;
endmodule
