module MipsProcessor(input myclk, myrst, output [31:0] myDataMemOut);
	
	wire myMemtoReg, mytoReg, myMemRead, myMemWrite, myPCsrc, myRegWrite, myJal, myRegDst, mytoPC_1, mytoPC_2, myALUsrc, myzero;
	wire [2:0] myALUop;
	wire [5:0] myopc, myfunc;
	
	DataPath My_DataPath(.clk(myclk), .rst(myrst), .MemtoReg(myMemtoReg), .toReg(mytoReg), .MemRead(myMemRead), .MemWrite(myMemWrite), .PCsrc(myPCsrc), .RegWrite(myRegWrite), .Jal(myJal), .RegDst(myRegDst), .toPC_1(mytoPC_1), .toPC_2(mytoPC_2), .ALUsrc(myALUsrc),
				.ALUop(myALUop), .zero(myzero), .DataMemOut(myDataMemOut), .opc(myopc), .func(myfunc));
				 
	Controller My_Controller(.zero(myzero), .opc(myopc), .func(myfunc), .MemtoReg(myMemtoReg), .toReg(mytoReg), .MemRead(myMemRead), .MemWrite(myMemWrite),
				.PCsrc(myPCsrc), .RegWrite(myRegWrite), .Jal(myJal), .RegDst(myRegDst), .toPC_1(mytoPC_1), .toPC_2(mytoPC_2), .ALUsrc(myALUsrc), .ALUop(myALUop));
				
endmodule