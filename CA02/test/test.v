module ALU (input [2:0]op, input [31:0]a, b, output reg [31:0]out, output reg zero);
	always @(op, a, b) begin
		case (op)
			3'b000 : out = a & b;
			3'b001 : out = a | b;
			3'b010 : out = a + b;
			3'b110 : out = a - b;
			3'b111 : out = (b>a) ? 32'd1 : 32'd0;
			default : out = 32'b0;
		endcase
	end
	
	assign zero = (out == 32'b0) ? 1'b1 : 1'b0;
endmodule