module HazardUnit(input IDEX_MemRead, input [4:0]IDEX_Rt, IFID_Rs, IFID_Rt, output reg PCwrite, IFIDwrite, HazardSel);
	assign HazardSel = 1'b0;
	assign 	PCwrite = 1'b1; 
	assign IFIDwrite = 1'b1;
	always @(IDEX_MemRead, IDEX_Rt, IFID_Rs, IFID_Rt) begin
		HazardSel = 1'b0; PCwrite = 1'b1; IFIDwrite = 1'b1;
		case(IDEX_Rt)
			IFID_Rs: begin
						if ((IDEX_MemRead == 1'b1) && (IDEX_Rt != 5'd0)) begin HazardSel = 1'b1; PCwrite = 1'b0; IFIDwrite = 1'b0; end
					 end
			IFID_Rt: begin
						if ((IDEX_MemRead == 1'b1) && (IDEX_Rt != 5'd0)) begin HazardSel = 1'b1; PCwrite = 1'b0; IFIDwrite = 1'b0; end
					 end
			default: begin HazardSel = 1'b0; PCwrite = 1'b1; IFIDwrite = 1'b1; end
		endcase
	end
endmodule