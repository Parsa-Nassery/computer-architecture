module Processor(input clk, rst, output [15:0] DataMemOut);
	
	wire PCload, IorD, IRwrite, toReg, MemRead, MemWrite, RegWrite, RegDst, ALUsrcB, zero;
	wire [1:0] ALUsrcA, PCsrc;
	wire [2:0] op;
	wire [3:0] opc;
	wire [8:0] func;
	
	DataPath MyDataPath(.clk(clk), .rst(rst), .PCload(PCload), .IorD(IorD), .IRwrite(IRwrite), .toReg(toReg), .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), .RegDst(RegDst), .ALUsrcB(ALUsrcB),
				.ALUsrcA(ALUsrcA), .PCsrc(PCsrc), .op(op), .zero(zero), .DataMemOut(DataMemOut), .func(func), .opc(opc));
				 
	Controller  myController(.clk(clk), .rst(rst), .zero(zero), .opc(opc), .func(func), .IorD(IorD), .IRwrite(IRwrite), .toReg(toReg), .MemRead(MemRead), .MemWrite(MemWrite),
				.RegWrite(RegWrite), .RegDst(RegDst), .ALUsrcB(ALUsrcB), .PCload(PCload), .ALUsrcA(ALUsrcA), .PCsrc(PCsrc), .op(op));
				  
endmodule