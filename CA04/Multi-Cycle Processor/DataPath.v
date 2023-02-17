module DataPath (input clk, rst, PCload, IorD, IRwrite, toReg, MemRead, MemWrite, RegWrite, RegDst, ALUsrcB,
				 input [1:0]ALUsrcA, PCsrc, input [2:0]op, output reg zero, output [15:0]DataMemOut, output reg [3:0]opc, output reg [8:0]func);
	
	wire [11:0] PCsrc_PCin;
	wire [11:0] PCout;
	wire [15:0] IRout;
	wire [11:0] MemAddress;
	wire [15:0] MemOut;
	wire [15:0] MDRout;
	wire [2:0] Mux_WriteReg;
	wire [15:0] Mux_WriteData;
	wire [15:0] ALUout;
	wire [15:0] Ainput;
	wire [15:0] Aoutput;
	wire [15:0] Binput;
	wire [15:0] Boutput;
	wire [15:0] SignOut1;
	wire [15:0] SignOut2;
	wire [15:0] ALUinA;
	wire [15:0] ALUinB;
	wire alu_zero;
	
	assign opc = IRout[15:12];
	assign func = IRout[8:0];
	assign DataMemOut = MemOut;
	assign zero = alu_zero;
	
	PC My_PC(.clk(clk), .rst(rst), .PCload(PCload), .PCin(PCsrc_PCin), .PCout(PCout));
	Mux2 #(12) My_Mux1(.s(IorD), .a(PCout), .b(IRout[11:0]), .out(MemAddress));
	Memory My_Mem(.clk(clk), .rst(rst), .MemRead(MemRead), .MemWrite(MemWrite), .address(MemAddress), .DataIn(Boutput), .out(MemOut));
	IR My_IR(.clk(clk), .rst(rst), .IRwrite(IRwrite), .IN(MemOut), .OUT(IRout));
	Reg16 MDR(.clk(clk), .rst(rst), .IN(MemOut), .OUT(MDRout));
	Mux2 #(3) My_Mux2(.s(RegDst), .a(IRout[11:9]), .b(3'b000), .out(Mux_WriteReg));
	Mux2 #(16) My_Mux3(.s(toReg), .a(MDRout), .b(ALUout), .out(Mux_WriteData));
	RegFile My_RegFile(.clk(clk), .RegWrite(RegWrite), .ReadReg1(IRout[11:9]), .ReadReg2(3'b000), .WriteReg(Mux_WriteReg), .WriteData(Mux_WriteData), .ReadData1(Ainput), .ReadData2(Binput));
	Reg16 A(.clk(clk), .rst(rst), .IN(Ainput), .OUT(Aoutput));
	Reg16 B(.clk(clk), .rst(rst), .IN(Binput), .OUT(Boutput));
	SignExtend My_sign1(.a(PCout), .out(SignOut1));
	SignExtend My_sign2(.a(IRout[11:0]), .out(SignOut2));
	Mux3 #(16) My_Mux4(.s(ALUsrcA), .a(SignOut1), .b(Aoutput), .c(SignOut2), .out(ALUinA));
	Mux2 #(16) My_Mux5(.s(ALUsrcB), .a(Boutput), .b(16'd1), .out(ALUinB));
	ALU My_ALU(.op(op), .a(ALUinA), .b(ALUinB), .out(ALUout), .zero(alu_zero));
	Mux3 #(12) My_Mux6(.s(PCsrc), .a(ALUout[11:0]), .b(IRout[11:0]), .c({PCout[11:9],IRout[8:0]}), .out(PCsrc_PCin));
	
endmodule

module Mux2 #(parameter N) (input s, input [N-1:0]a, b, output [N-1:0]out);
	assign out = s ? b : a;
endmodule

module Mux3 #(parameter N) (input [1:0]s, input [N-1:0]a, b, c, output [N-1:0]out);
	assign out = (s == 2'b10) ? c : ((s == 2'b01) ? b : a);
endmodule

module PC (input clk, rst, PCload, input [11:0] PCin, output [11:0] PCout);
	reg [11:0] PCreg = 12'b0;
	
	always @(posedge clk, posedge rst) begin
		if (rst)
			PCreg <= 12'b0;
		else if (PCload)
			PCreg <= PCin;
	end
	
	assign PCout = PCreg;
endmodule

module ALU (input [2:0]op, input [15:0]a, b, output reg [15:0]out, output reg zero);
	
	always @(op, a, b) begin
		case (op)
			3'b010 : out = a & b;
			3'b001 : out = b - a;
			3'b000 : out = a + b;
			3'b011 : out = a | b;
			3'b100 : out = ~(a);
			3'b101 : out = a;
			3'b110 : out = b;
			default : out = 16'b0;
		endcase
	end
	
	assign zero = (out == 16'b0) ? 1'b1 : 1'b0;
endmodule

module SignExtend (input [11:0]a, output [15:0]out);
	assign out = (a[11]) ? {4'b1, a} : {4'b0, a};
endmodule

module Memory (input clk, rst, MemRead, MemWrite, input [11:0]address, input [15:0]DataIn, output [15:0]out);
	reg [15:0] Mem [0:4095];
	
	initial begin
		$readmemb("Data.mem", Mem, 3000);
		$readmemb("DataArray.mem", Mem, 1000);
		$readmemb("Inst.mem", Mem);
	end
	always @(posedge clk) begin
		if (MemWrite)
			Mem[address] <= DataIn;
	end
	assign out = MemRead ? Mem[address] : 16'b0;
endmodule

module RegFile (input clk, RegWrite, input [2:0]ReadReg1, ReadReg2, WriteReg, input [15:0]WriteData, output reg [15:0]ReadData1, ReadData2);
	reg [15:0] R [0:7];


	always @(posedge clk) begin
		if (RegWrite)
			R[WriteReg] <= WriteData;
	end
	
	assign ReadReg2 = 3'b000;
	assign ReadData1 = R[ReadReg1];
	assign ReadData2 = R[ReadReg2];
endmodule

module Reg16 (input clk, rst, input [15:0]IN, output [15:0]OUT);
	reg [15:0] register;
	
	always @(posedge clk, posedge rst) begin
		if (rst)
			register <= 16'b0;
		else
			register <= IN;
	end
	
	assign OUT = register;

endmodule

module IR (input clk, rst, IRwrite, input [15:0]IN, output [15:0]OUT);
	reg [15:0] register;
	
	always @(posedge clk, posedge rst) begin
		if (rst)
			register <= 16'b0;
		else if (IRwrite)
			register <= IN;
	end
	
	assign OUT = register;

endmodule