module DataPath (input clk, rst, HazardSel, IF_Flush, IFID_Write, PCwrite, MemtoReg, toReg, MemRead, MemWrite, PCsrc, RegWrite, Jal, RegDst, toPC_1, toPC_2, ALUsrc,
				 input [1:0]ForwardA, ForwardB, input [2:0]ALUop, HalaOP, output reg zero, equal, MemReadIDEX, RegWriteEXMEM, RegWriteMEMWB, output [31:0]DataMemOut, output reg [4:0]RsIFID, RtIFID, RsIDEX, RtIDEX, RdEXMEM, RdMEMWB, output reg [5:0]opc, func,
				 output reg [31:0] CompA, CompB, A,B,ALUout, PCinit, PC4IFID, Inst_IF, IF_Inst, PCOUTTTT, IFID_PC4, MuxPCsrcOut, Muxto_pc1out);

	wire [31:0] Inst;
	wire [31:0] PC2_PCin;
	wire [31:0] PCout;
	wire [31:0] toReg_WriteData;
	wire [31:0] RegOut1_IDEX, IDEX_RegOut1;
	wire [31:0] RegOut2_IDEX, IDEX_RegOut2;
	wire [31:0] MEMout_MEMWB, MEMWB_MEMout;
	wire [31:0] ALUresult, EXMEM_ALUresult_MEMWB, MEMWB_ALUresult;
	wire [31:0] SignEX_IDEX, IDEX_SignEX;
	wire [31:0] SHL26_PC2;
	wire [31:0] SHL32_Adder;
	wire [31:0] AdderOut1;
	wire [31:0] AdderOut2;
	wire [31:0] Mux1_4;
	wire [31:0] Mux2_8;
	wire [31:0] Mux8_7;
	wire [31:0] Mux3_ALU;
	wire [31:0] PC4_IFID, IFID_PC4_IDEX, IDEX_PC4_EXMEM, EXMEM_PC4_MEMWB, MEMWB_PC4;
	wire [31:0] Inst_IFID, IFID_Inst, InstOut, HazardInstOut;
	wire [31:0] ForwardB_Out, ForwardA_Out, EXMEM_ForwardB;
	wire [4:0] Mux6_5, Jal_EXMEM, IDEX_Rt, IDEX_Rs, IDEX_Rd, EXMEM_R_MEMWB, MEMWB_R;
	wire [2:0] IDEX_ALUop;
	wire alu_zero, CompOut;
	wire IDEX_MemtoReg_EXMEM, IDEX_toReg_EXMEM, IDEX_MemRead_EXMEM, IDEX_MemWrite_EXMEM, IDEX_RegWrite_EXMEM, IDEX_Jal, IDEX_RegDst, IDEX_ALUsrc;
	wire EXMEM_Zero_MEMWB, EXMEM_MemtoReg_MEMWB, EXMEM_toReg_MEMWB, EXMEM_MemRead, EXMEM_MemWrite, EXMEM_RegWrite_MEMWB;
	wire MEMWB_MemtoReg, MEMWB_toReg, MEMWB_RegWrite;
	
	assign PC4IFID = PC4_IFID;
	assign IFID_PC4 = IFID_PC4_IDEX;
	assign Inst_IF = Inst_IFID;
	assign PCinit = PC2_PCin;
	assign PCOUTTTT = PCout;
	assign opc = HazardInstOut[31:26];
	assign func = HazardInstOut[5:0];
	assign RsIFID = HazardInstOut[25:21];
	assign RtIFID = HazardInstOut[20:16];
	assign RsIDEX = IDEX_Rs;
	assign RtIDEX = IDEX_Rt;
	assign DataMemOut = MEMout_MEMWB;
	assign zero = alu_zero;
	assign equal = CompOut;
	assign MemReadIDEX = IDEX_MemRead_EXMEM;
	assign RegWriteEXMEM = EXMEM_RegWrite_MEMWB;
	assign RegWriteMEMWB = MEMWB_RegWrite;
	assign RdEXMEM = EXMEM_R_MEMWB;
	assign RdMEMWB = MEMWB_R;
	assign IF_Inst = IFID_Inst;
	assign MuxPCsrcOut = Mux2_8;
	assign Muxto_pc1out = Mux8_7;
	assign A = ForwardA_Out;
	assign B = Mux3_ALU;
	assign ALUout = ALUresult;
	assign HalaOP = IDEX_ALUop;
	assign CompA = RegOut1_IDEX;
	assign CompB = RegOut2_IDEX;
	
	HazardMux My_HazardMux(.HazardSel(HazardSel), .inst(IFID_Inst), .instOut(HazardInstOut));
	IF_ID_Reg My_IF_ID(.clk(clk), .IF_Flush(IF_Flush), .IF_ID_Write(IFID_Write), .InstIn(Inst_IFID), .PC4In(PC4_IFID), .InstOut(IFID_Inst), .PC4Out(IFID_PC4_IDEX));
	ID_EX_Reg My_ID_EX(.clk(clk), .MemtoRegIn(MemtoReg), .toRegIn(toReg), .MemReadIn(MemRead), .MemWriteIn(MemWrite), .RegWriteIn(RegWrite), .JalIn(Jal), .RegDstIn(RegDst), .ALUsrcIn(ALUsrc),
					   .ALUopIn(ALUop), .RtIn(HazardInstOut[20:16]), .RsIn(HazardInstOut[25:21]), .RdIn(HazardInstOut[15:11]), .ExtendedIn(SignEX_IDEX), .Data1In(RegOut1_IDEX), .Data2In(RegOut2_IDEX),
					   .PC4In(IFID_PC4_IDEX), .MemtoRegOut(IDEX_MemtoReg_EXMEM), .toRegOut(IDEX_toReg_EXMEM), .MemReadOut(IDEX_MemRead_EXMEM), .MemWriteOut(IDEX_MemWrite_EXMEM),
					   .RegWriteOut(IDEX_RegWrite_EXMEM), .JalOut(IDEX_Jal), .RegDstOut(IDEX_RegDst), .ALUsrcOut(IDEX_ALUsrc), .ALUopOut(IDEX_ALUop), .RtOut(IDEX_Rt),
					   .RsOut(IDEX_Rs), .RdOut(IDEX_Rd), .PC4Out(IDEX_PC4_EXMEM), .ExtendedOut(IDEX_SignEX), .Data1Out(IDEX_RegOut1), .Data2Out(IDEX_RegOut2));
	EX_MEM_Reg My_EX_MEM(.clk(clk), .MemtoRegIn(IDEX_MemtoReg_EXMEM), .toRegIn(IDEX_toReg_EXMEM), .MemReadIn(IDEX_MemRead_EXMEM), .MemWriteIn(IDEX_MemWrite_EXMEM), .RegWriteIn(IDEX_RegWrite_EXMEM),
						 .ZeroIn(alu_zero), .RIn(Jal_EXMEM), .ALUresultIn(ALUresult), .BIn(ForwardB_Out), .PC4In(IDEX_PC4_EXMEM), .ZeroOut(EXMEM_Zero_MEMWB), .MemtoRegOut(EXMEM_MemtoReg_MEMWB),
						 .toRegOut(EXMEM_toReg_MEMWB), .MemReadOut(EXMEM_MemRead), .MemWriteOut(EXMEM_MemWrite), .RegWriteOut(EXMEM_RegWrite_MEMWB), .ROut(EXMEM_R_MEMWB), .PC4Out(EXMEM_PC4_MEMWB),
						 .ALUresultOut(EXMEM_ALUresult_MEMWB), .BOut(EXMEM_ForwardB));
	MEM_WB_Reg My_MEM_WB(.clk(clk), .MemtoRegIn(EXMEM_MemtoReg_MEMWB), .toRegIn(EXMEM_toReg_MEMWB), .RegWriteIn(EXMEM_RegWrite_MEMWB), .ZeroIn(EXMEM_Zero_MEMWB), .RIn(EXMEM_R_MEMWB),
						 .ALUresultIn(EXMEM_ALUresult_MEMWB), .PC4In(EXMEM_PC4_MEMWB), .DataMemIn(MEMout_MEMWB), .MemtoRegOut(MEMWB_MemtoReg), .toRegOut(MEMWB_toReg), .RegWriteOut(MEMWB_RegWrite), .ROut(MEMWB_R),
						 .PC4Out(MEMWB_PC4), .ALUresultOut(MEMWB_ALUresult), .DataMemOut(MEMWB_MEMout));
	
	PC My_PC(.clk(clk), .PCwrite(PCwrite), .rst(rst), .PCin(PC2_PCin), .PCout(PCout));
	InstMem My_InstMem(.address(PCout), .out(Inst_IFID));
	RegFile My_RegFile(.clk(clk), .RegWrite(MEMWB_RegWrite), .ReadReg1(HazardInstOut[25:21]), .ReadReg2(HazardInstOut[20:16]), .WriteReg(MEMWB_R), .WriteData(toReg_WriteData), .ReadData1(RegOut1_IDEX), .ReadData2(RegOut2_IDEX));
	DataMem My_DataMem(.clk(clk), .rst(rst), .MemRead(EXMEM_MemRead), .MemWrite(EXMEM_MemWrite), .address(EXMEM_ALUresult_MEMWB), .DataIn(EXMEM_ForwardB), .out(MEMout_MEMWB));
	ALU My_ALU(.op(IDEX_ALUop), .a(ForwardA_Out), .b(Mux3_ALU), .out(ALUresult), .zero(alu_zero));
	SignExtend My_SignExtend(.a(HazardInstOut[15:0]), .out(SignEX_IDEX));
	ShiftLeft32bit My_ShiftLeft32bit(.a(SignEX_IDEX), .out(SHL32_Adder));
	ShiftLeft26bit My_ShiftLeft26bit(.a(HazardInstOut[25:0]), .out(SHL26_PC2));
	Adder My_Adder1(.a(32'd1), .b(PCout), .out(PC4_IFID));
	Adder My_Adder2(.a(IFID_PC4_IDEX), .b(SignEX_IDEX), .out(AdderOut2));
	Comparator My_Comparator(.a(RegOut1_IDEX), .b(RegOut2_IDEX), .Equal(CompOut));
	Mux3 #(32) My_ForwardA(.s(ForwardA), .a(IDEX_RegOut1), .b(EXMEM_ALUresult_MEMWB), .c(Mux1_4), .out(ForwardA_Out));
	Mux3 #(32) My_ForwardB(.s(ForwardB), .a(IDEX_RegOut2), .b(EXMEM_ALUresult_MEMWB), .c(Mux1_4), .out(ForwardB_Out));
	Mux2 #(32) My_Mux1(.s(MEMWB_MemtoReg), .a(MEMWB_ALUresult), .b(MEMWB_MEMout), .out(Mux1_4));
	Mux2 #(32) My_Mux2(.s(PCsrc), .a(PC4_IFID), .b(AdderOut2), .out(Mux2_8));
	Mux2 #(32) My_Mux3(.s(IDEX_ALUsrc), .a(ForwardB_Out), .b(IDEX_SignEX), .out(Mux3_ALU));
	Mux2 #(32) My_Mux4(.s(MEMWB_toReg), .a(MEMWB_PC4), .b(Mux1_4), .out(toReg_WriteData));
	Mux2 #(5) My_Mux5(.s(IDEX_Jal), .a(Mux6_5), .b(5'd31), .out(Jal_EXMEM));
	Mux2 #(5) My_Mux6(.s(IDEX_RegDst), .a(IDEX_Rt), .b(IDEX_Rd), .out(Mux6_5));
	Mux2 #(32) My_Mux7(.s(toPC_2), .a(Mux8_7), .b({PCout[31:26], IFID_Inst[25:0]}), .out(PC2_PCin));
	Mux2 #(32) My_Mux8(.s(toPC_1), .a(RegOut1_IDEX), .b(Mux2_8), .out(Mux8_7));
	
endmodule

module Mux2 #(parameter N) (input s, input [N-1:0]a, b, output [N-1:0]out);
	assign out = s ? b : a;
endmodule

module Mux3 #(parameter N) (input [1:0]s, input [N-1:0]a, b, c, output [N-1:0]out);
	assign out = (s == 2'b10) ? c : ((s == 2'b01) ? b : a);
endmodule

module Adder (input [31:0]a, b, output [31:0]out);
	wire Cout;
	assign {Cout, out} = a + b;
endmodule

module PC (input clk, rst, PCwrite, input [31:0]PCin, output [31:0]PCout);
	reg [31:0] PCreg = 32'b0;
	
	always @(posedge clk, posedge rst) begin
		if (rst)
			PCreg <= 32'b0;
		else if (PCwrite)
			PCreg <= PCin;
	end
	
	assign PCout = PCreg;
endmodule

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

module SignExtend (input [15:0]a, output [31:0]out);
	assign out = (a[15]) ? {16'b1, a} : {16'b0, a};
endmodule

module ShiftLeft32bit (input [31:0]a, output [31:0]out);
	assign out = a << 2;
endmodule

module ShiftLeft26bit (input [25:0]a, output [27:0]out);
	assign out = a << 2;
endmodule

module DataMem (input clk, rst, MemRead, MemWrite, input[31:0]address, DataIn, output[31:0]out);
	reg [31:0] Mem [0:65535];
	
	initial begin
		$readmemb("DataMem.mem", Mem, 1000);
	end
	always @(posedge clk) begin
		if (MemWrite)
			Mem[address] <= DataIn;
	end
	assign out = MemRead ? Mem[address] : 32'b0;
endmodule

module InstMem (input [31:0] address, output reg [31:0] out);
	reg [31:0] Inst [0:65535];
	
	initial begin
		$readmemb("Inst.mem", Inst);
	end
	
	always @(address) begin
		out = Inst[address];
	end
endmodule

module RegFile (input clk, RegWrite, input [4:0]ReadReg1, ReadReg2, WriteReg, input [31:0]WriteData, output reg [31:0]ReadData1, ReadData2);
	reg [31:0] R [0:31];


	always @(negedge clk) begin
		if ((RegWrite) & (WriteReg != 1'b0))
			R[WriteReg] <= WriteData;
	end
	
	assign ReadData1 = R[ReadReg1];
	assign ReadData2 = R[ReadReg2];
	assign R[0] = 32'b0;
endmodule

module IF_ID_Reg (input clk, IF_Flush, IF_ID_Write, input [31:0]InstIn, PC4In, output reg [31:0]InstOut, PC4Out);
	always @(posedge clk) begin
		if (IF_Flush == 1'b1) begin
			InstOut <= {1'b1, 31'b0};
			PC4Out <= PC4In;
		end
		else begin
			if (IF_ID_Write == 1'b1) begin
				InstOut <= InstIn;
				PC4Out <= PC4In;
			end
		end
	end
endmodule

module ID_EX_Reg (input clk, MemtoRegIn, toRegIn, MemReadIn, MemWriteIn, RegWriteIn, JalIn, RegDstIn, ALUsrcIn, input [2:0]ALUopIn,
				  input [4:0]RtIn, RsIn, RdIn, input [31:0]ExtendedIn, Data1In, Data2In, PC4In, output reg MemtoRegOut, toRegOut, MemReadOut, MemWriteOut,
				  RegWriteOut, JalOut, RegDstOut, ALUsrcOut, output reg [2:0]ALUopOut, output reg [4:0]RtOut, RsOut, RdOut, output reg [31:0]PC4Out, ExtendedOut, Data1Out, Data2Out);

	always @(posedge clk) begin
		MemtoRegOut <= MemtoRegIn;
		toRegOut <= toRegIn;
		MemReadOut <= MemReadIn;
		MemWriteOut <= MemWriteIn;
		RegWriteOut <= RegWriteIn;
		JalOut <= JalIn;
		RegDstOut <= RegDstIn;
		ALUsrcOut <= ALUsrcIn;
		ALUopOut <= ALUopIn;
		RtOut <= RtIn;
		RsOut <= RsIn;
		RdOut <= RdIn;
		ExtendedOut <= ExtendedIn;
		Data1Out <= Data1In;
		Data2Out <= Data2In;
		PC4Out <= PC4In;
	end

endmodule

module EX_MEM_Reg (input clk, MemtoRegIn, toRegIn, MemReadIn, MemWriteIn, RegWriteIn, ZeroIn, input [4:0]RIn, 
				   input [31:0] ALUresultIn, BIn, PC4In, output reg ZeroOut, MemtoRegOut, toRegOut, MemReadOut,
				   MemWriteOut, RegWriteOut, output reg [4:0]ROut, output reg [31:0]PC4Out, ALUresultOut, BOut);

	always @(posedge clk) begin
		MemtoRegOut <= MemtoRegIn;
		toRegOut <= toRegIn;
		MemReadOut <= MemReadIn;
		MemWriteOut <= MemWriteIn;
		RegWriteOut <= RegWriteIn;
		ROut <= RIn;
		BOut <= BIn;
		ALUresultOut <= ALUresultIn;
		ZeroOut <= ZeroIn;
		PC4Out <= PC4In;
	end
	
endmodule

module MEM_WB_Reg (input clk, MemtoRegIn, toRegIn, RegWriteIn, ZeroIn, input [4:0]RIn, 
				   input [31:0] ALUresultIn, PC4In, DataMemIn, output reg MemtoRegOut, toRegOut,
				   RegWriteOut, output reg [4:0]ROut, output reg [31:0]PC4Out, ALUresultOut, DataMemOut);
				   
	always @(posedge clk) begin
		DataMemOut <= DataMemIn;
		MemtoRegOut <= MemtoRegIn;
		toRegOut <= toRegIn;
		RegWriteOut <= RegWriteIn;
		ROut <= RIn;
		ALUresultOut <= ALUresultIn;
		PC4Out <= PC4In;
	end

endmodule

module Comparator(input [31:0]a, b, output reg Equal);
	assign Equal = 1'b0;
	always @(a,b) begin
		Equal = 1'b0;
		case(a)
			b: begin Equal = 1'b1; end
			default: Equal = 1'b0;
		endcase
	end
endmodule

module HazardMux (input HazardSel, input [31:0]inst, output reg [31:0]instOut);
	assign instOut = inst;
	always @(HazardSel) begin
		instOut = (HazardSel) ? {1'b1, 31'b0} : inst;
	end
endmodule