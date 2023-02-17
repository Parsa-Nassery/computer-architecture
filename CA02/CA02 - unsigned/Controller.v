module Controller(input zero, input [31:0] ALUres, input [5:0]opc, func, output reg MemtoReg, toReg, MemRead, MemWrite,
				  PCsrc, RegWrite, Jal, RegDst, toPC_1, toPC_2, ALUsrc, output reg [2:0]ALUop);
	
	parameter [5:0] R_Type = 6'b000000, j = 6'b000001, jr = 6'b000011, jal = 6'b000111, addi = 6'b001111,
					beq = 6'b011111, slti = 6'b111111, sw = 6'b111110, lw = 6'b111100;
	
	parameter [5:0] Add = 6'b100000, Sub = 6'b010000, And = 6'b001000, Or = 6'b000100, Slt = 6'b000010;
	
	always @(opc, func) begin
		MemtoReg = 1'b0; toReg = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0;
		Jal = 1'b0; RegDst = 1'b0; toPC_1 = 1'b0; toPC_2 = 1'b0; ALUsrc = 1'b0; ALUop = 3'b0;
		case(opc)
			R_Type: begin
				RegWrite = 1'b1; toReg = 1'b1; RegDst = 1'b1; toPC_1 = 1'b1;
				case(func)
					Add: begin ALUop = 3'b010; end
					Sub: begin ALUop = 3'b110; end
					And: begin ALUop = 3'b000; end
					Or: begin ALUop = 3'b001; end
					Slt: begin ALUop = 3'b111; end
				endcase
			end
			
			j: begin toPC_2 = 1'b1; end
			jr: begin toPC_2 = 1'b0; end
			jal: begin RegWrite = 1'b1; Jal = 1'b1; toPC_2 = 1'b1; end
			beq: begin ALUop = 3'b110; toPC_1 = 1'b1; end
			sw: begin MemWrite = 1'b1; ALUop = 3'b010; ALUsrc = 1'b1; toPC_1 = 1'b1; end
			lw: begin MemtoReg = 1'b1; MemRead = 1'b1; ALUop = 3'b010; ALUsrc = 1'b1; RegWrite = 1'b1; toReg = 1'b1; toPC_1 = 1'b1; end
			addi: begin ALUop = 3'b010; ALUsrc = 1'b1; RegWrite = 1'b1; toReg = 1'b1; toPC_1 = 1'b1; end
			slti: begin ALUop = 3'b111; ALUsrc = 1'b1; RegWrite = 1'b1; toReg = 1'b1; toPC_1 = 1'b1; end
		endcase
	end
	assign PCsrc = zero ? ((opc == beq) ? 1'b1 : 1'b0) : 1'b0;
endmodule