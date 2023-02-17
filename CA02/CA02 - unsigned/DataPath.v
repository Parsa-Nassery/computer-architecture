module DataPath (input clk, rst, MemtoReg, toReg, MemRead, MemWrite, PCsrc, RegWrite, Jal, RegDst, toPC_1, toPC_2, ALUsrc,
				 input [2:0]ALUop, output reg zero, output [31:0]DataMemOut, output reg [5:0]opc, func);

	wire [31:0] Inst;
	wire [31:0] PC2_PCin;
	wire [31:0] PCout;
	wire [31:0] toReg_WriteData;
	wire [31:0] RegOut1;
	wire [31:0] RegOut2;
	wire [31:0] MEMout;
	wire [31:0] ALUresult;
	wire [31:0] SignEXout;
	wire [31:0] SHL26_PC2;
	wire [31:0] SHL32_Adder;
	wire [31:0] AdderOut1;
	wire [31:0] AdderOut2;
	wire [31:0] Mux1_4;
	wire [31:0] Mux2_8;
	wire [31:0] Mux8_7;
	wire [31:0] Mux3_ALU;
	wire [4:0] Mux6_5;
	wire [4:0] Jal_WriteReg;
	wire alu_zero;
	
	assign opc = Inst[31:26];
	assign func = Inst[5:0];
	assign DataMemOut = MEMout;
	assign zero = alu_zero;
	
	PC My_PC(.clk(clk), .rst(rst), .PCin(PC2_PCin), .PCout(PCout));
	InstMem My_InstMem(.address(PCout), .out(Inst));
	RegFile My_RegFile(.clk(clk), .RegWrite(RegWrite), .ReadReg1(Inst[25:21]), .ReadReg2(Inst[20:16]), .WriteReg(Jal_WriteReg), .WriteData(toReg_WriteData), .ReadData1(RegOut1), .ReadData2(RegOut2));
	DataMem My_DataMem(.clk(clk), .rst(rst), .MemRead(MemRead), .MemWrite(MemWrite), .address(ALUresult), .DataIn(RegOut2), .out(MEMout));
	ALU My_ALU(.op(ALUop), .a(RegOut1), .b(Mux3_ALU), .out(ALUresult), .zero(alu_zero));
	SignExtend My_SignExtend(.a(Inst[15:0]), .out(SignEXout));
	ShiftLeft32bit My_ShiftLeft32bit(.a(SignEXout), .out(SHL32_Adder));
	ShiftLeft26bit My_ShiftLeft26bit(.a(Inst[25:0]), .out(SHL26_PC2));
	Adder My_Adder1(.a(32'd1), .b(PCout), .out(AdderOut1));
	Adder My_Adder2(.a(AdderOut1), .b(SignEXout), .out(AdderOut2));
	Mux2 #(32) My_Mux1(.s(MemtoReg), .a(ALUresult), .b(MEMout), .out(Mux1_4));
	Mux2 #(32) My_Mux2(.s(PCsrc), .a(AdderOut1), .b(AdderOut2), .out(Mux2_8));
	Mux2 #(32) My_Mux3(.s(ALUsrc), .a(RegOut2), .b(SignEXout), .out(Mux3_ALU));
	Mux2 #(32) My_Mux4(.s(toReg), .a(AdderOut1), .b(Mux1_4), .out(toReg_WriteData));
	Mux2 #(5) My_Mux5(.s(Jal), .a(Mux6_5), .b(5'd31), .out(Jal_WriteReg));
	Mux2 #(5) My_Mux6(.s(RegDst), .a(Inst[20:16]), .b(Inst[15:11]), .out(Mux6_5));
	Mux2 #(32) My_Mux7(.s(toPC_2), .a(Mux8_7), .b({PCout[31:26], Inst[25:0]}), .out(PC2_PCin));
	Mux2 #(32) My_Mux8(.s(toPC_1), .a(RegOut1), .b(Mux2_8), .out(Mux8_7));
	
endmodule

module Mux2 #(parameter N) (input s, input [N-1:0]a, b, output [N-1:0]out);
	assign out = s ? b : a;
endmodule

module Adder (input [31:0]a, b, output [31:0]out);
	wire Cout;
	assign {Cout, out} = a + b;
endmodule

module PC (input clk, rst, input [31:0] PCin, output [31:0] PCout);
	reg [31:0] PCreg = 32'b0;
	
	always @(posedge clk, posedge rst) begin
		if (rst)
			PCreg <= 32'b0;
		else
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


	always @(posedge clk) begin
		if ((RegWrite) & (WriteReg != 1'b0))
			R[WriteReg] <= WriteData;
	end
	
	assign ReadData1 = R[ReadReg1];
	assign ReadData2 = R[ReadReg2];
	assign R[0] = 32'b0;
endmodule