

module DataLoader(input clk, rst, cnt1, cnt2, ld_1, ld_2, output [19:0] xi, yi, output Cout1, Cout2);
	reg [19:0] memx [0:149];
	reg [19:0] memy [0:149];
	reg [7:0] PO1;
	reg [2:0] PO2;

	initial $readmemb("x_value.txt",memx);
	initial $readmemb("y_value.txt",memy);
	
	always @(posedge clk, posedge rst) begin
		if (rst)
			PO1 <= 8'b0;
		else begin
			if(ld_1)
				PO1 <= 8'd106;
			else if (cnt1) PO1 <= PO1 + 1;
		end
	end
	assign Cout1 = (cnt1) ? &{PO1, 1'b1} : 1'b0;
	
	always @(posedge clk, posedge rst) begin
		if (rst)
			PO2 <= 3'b0;
		else begin
			if(ld_2)
				PO2 <= 3'b0;
			else if (cnt2) PO2 <= PO2 + 1;
		end	
	end
	assign Cout2 = (cnt2) ? &{PO2, 1'b1} : 1'b0;

	assign xi = memx[PO1 - 8'b01101010];
	assign yi = memy[PO1 - 8'b01101010];
endmodule
