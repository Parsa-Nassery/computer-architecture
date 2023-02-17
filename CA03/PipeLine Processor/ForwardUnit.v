module ForwardUnit(input EXMEM_RegWrite, MEMWB_RegWrite, input [4:0]IDEX_Rt, IDEX_Rs, EXMEM_Rd, MEMWB_Rd, output reg [1:0]ForwardA, ForwardB);
	
	assign ForwardA = 2'b0;
	assign ForwardB = 2'b0;

	
	always @(EXMEM_RegWrite, MEMWB_RegWrite, IDEX_Rt, IDEX_Rs, EXMEM_Rd, MEMWB_Rd) begin
		assign ForwardA = ((EXMEM_RegWrite) && (EXMEM_Rd == IDEX_Rs) && (EXMEM_Rd != 5'd0)) ? 2'b01 :
							((MEMWB_RegWrite) && (MEMWB_Rd == IDEX_Rs) && (MEMWB_Rd != 5'd0)) ? 2'b10 : 2'b0;
	
		assign ForwardB = ((EXMEM_RegWrite) && (EXMEM_Rd == IDEX_Rt) && (EXMEM_Rd != 5'd0)) ? 2'b01 :
							((MEMWB_RegWrite) && (MEMWB_Rd == IDEX_Rt) && (MEMWB_Rd != 5'd0)) ? 2'b10 : 2'b0;
	end
endmodule