module Controller(input clk, rst, input zero, input [3:0]opc, input [8:0]func, output reg IorD, IRwrite, toReg, MemRead, MemWrite,
				  RegWrite, RegDst, ALUsrcB, PCload, output reg [1:0]ALUsrcA, PCsrc, output reg [2:0]op);
	
	reg [3:0] ns, ps;
	reg [2:0] ALUop;
	reg PCwrite, PCwriteCond;
	
	parameter [3:0] IF = 4'd0, ID = 4'd1, BranchState = 4'd2, LoadState = 4'd3, StoreState = 4'd4, JumpState = 4'd5, CTypeState1 = 4'd6,
					CTypeState2 = 4'd7, AddiState = 4'd8, SubiState = 4'd9, AndiState = 4'd10, OriState = 4'd11;
	
	parameter [3:0] Load = 4'b0000, Store = 4'b0001, Jump = 4'b0010, Branch = 4'b0100, CType = 4'b1000, Addi = 4'b1100, Subi = 4'b1101, Andi = 4'b1110, Ori = 4'b1111;
	
	parameter [8:0] Moveto = 9'b000000001, MoveFrom = 9'b000000010, Add = 9'b000000100, Sub = 9'b000001000, And = 9'b000010000, Or = 9'b000100000, NotA = 9'b001000000, Nop = 9'b010000000;
	
	always @(ps, opc, func, clk) begin
		ns = IF;
		case(ps)
			IF: ns = ID;
			ID: case(opc)
					Branch: ns = BranchState;
					Load: ns = LoadState;
					Store: ns = StoreState;
					Jump: ns = JumpState;
					CType: ns = (func == 9'b000000001) ? CTypeState1 : ((func == 9'b010000000) ? IF : CTypeState2);
					Addi: ns = AddiState;
					Subi: ns = SubiState;
					Andi: ns = AndiState;
					Ori: ns = OriState;
				endcase
			BranchState: ns = IF;
			LoadState: ns = IF;
			StoreState: ns = IF;
			JumpState: ns = IF;
			CTypeState1: ns = IF;
			CTypeState2: ns = IF;
			AddiState: ns = IF;
			OriState: ns = IF;
			AndiState: ns = IF;
			SubiState: ns = IF;
		endcase
	end
	
	always @(ps, clk) begin
		IorD = 1'b0; IRwrite = 1'b0; toReg = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; PCwrite = 1'b0; PCwriteCond = 1'b0;
		RegWrite = 1'b0; RegDst = 1'b0; ALUsrcB = 1'b0; ALUsrcA = 2'b00; ALUop = 3'b000;
		case(ps)
			IF: begin MemRead = 1'b1; ALUsrcA = 2'b00; ALUsrcB = 1'b1; IRwrite = 1'b1; PCwrite = 1'b1; ALUop = 3'b000; end
			ID: begin IorD = 1'b1; MemRead = 1'b1; end
			BranchState: begin ALUsrcA = 2'b01; ALUsrcB = 1'b0; PCwriteCond = 1'b1; ALUop = 3'b001; end
			LoadState: begin RegDst = 1'b1; RegWrite = 1'b1; end
			StoreState: begin IorD = 1'b1; MemWrite = 1'b1; end
			JumpState: begin PCwrite = 1'b1; end
			CTypeState1: begin toReg = 1'b1; RegWrite = 1'b1; ALUsrcA = 2'b01; ALUsrcB = 1'b0; ALUop = 3'b100; end
			CTypeState2: begin toReg = 1'b1; RegWrite = 1'b1; RegDst = 1'b1; ALUsrcA = 2'b01; ALUsrcB = 1'b0; ALUop = 3'b100; end
			AddiState: begin toReg = 1'b1; RegDst = 1'b1; ALUsrcA = 2'b10; ALUsrcB = 1'b0; RegWrite = 1'b1; ALUop = 3'b000; end
			SubiState: begin toReg = 1'b1; RegDst = 1'b1; ALUsrcA = 2'b10; ALUsrcB = 1'b0; RegWrite = 1'b1; ALUop = 3'b001; end
			AndiState: begin toReg = 1'b1; RegDst = 1'b1; ALUsrcA = 2'b10; ALUsrcB = 1'b0; RegWrite = 1'b1; ALUop = 3'b010; end
			OriState: begin toReg = 1'b1; RegDst = 1'b1; ALUsrcA = 2'b10; ALUsrcB = 1'b0; RegWrite = 1'b1; ALUop = 3'b011; end
		endcase
	end
	
	always @(posedge clk, posedge rst) begin
		if (rst) ps = IF;
		else ps = ns;
	end
	
	assign PCload = PCwrite ? 1'b1 : (PCwriteCond ? (zero ? 1'b1 : 1'b0) : 1'b0);
	assign PCsrc = (ps == JumpState) ? 2'b01 : ((ps == BranchState) ? (zero ? 2'b10 : 2'b00) : 2'b00);
	
	always @(ALUop) begin
		case(ALUop)
			3'b000: op = 3'b000;
			3'b001: op = 3'b001;
			3'b010: op = 3'b010;
			3'b011: op = 3'b011;
			3'b100: case(func)
						Moveto: op = 3'b110;
						MoveFrom: op = 3'b101;
						Add: op = 3'b000;
						Sub: op = 3'b001;
						And: op = 3'b010;
						Or: op = 3'b011;
						NotA: op = 3'b100;
					endcase
		endcase
	end
endmodule	