module MipsProcessor(input clk, rst, output [31:0] myDataMemOut);
	
	wire myMemtoReg, mytoReg, myMemRead, myMemWrite, myPCsrc, myRegWrite, myJal, myRegDst, mytoPC_1, mytoPC_2, myALUsrc, myzero;
	wire Hazard, Equal, Flush, IFID_write, PC_write;
	wire IDEXmemread, EXMEMregwrite, MEMWBregwrite;
	wire [1:0] myForwardA, myForwardB;
	wire [2:0] myALUop, HalaOP;
	wire [5:0] myopc, myfunc;
	wire [4:0] IFIDrs, IFIDrt, IDEXrs, IDEXrt, EXMEMrd, MEMWBrd;
	wire [31:0] CompA,CompB, PCinit, PC4IFID,IF_Inst,Inst_IF, PPCCCC, IFID_PC4, MuxPCsrcOut, Muxto_pc1out, ALUout, A,B;
	
	DataPath My_DataPath(.CompB(CompB), .CompA(CompA), .HalaOP(HalaOP), .A(A), .B(B), .ALUout(ALUout), .Muxto_pc1out(Muxto_pc1out), .MuxPCsrcOut(MuxPCsrcOut), .IFID_PC4(IFID_PC4), .IF_Inst(IF_Inst), .Inst_IF(Inst_IF), .PC4IFID(PC4IFID), .PCinit(PCinit),.clk(clk), .rst(rst), .PCOUTTTT(PPCCCC), .HazardSel(Hazard), .IF_Flush(Flush), .IFID_Write(IFID_write), .PCwrite(PC_write), .MemtoReg(myMemtoReg),
						 .toReg(mytoReg), .MemRead(myMemRead), .MemWrite(myMemWrite), .PCsrc(myPCsrc), .RegWrite(myRegWrite), .Jal(myJal), .RegDst(myRegDst),
						 .toPC_1(mytoPC_1), .toPC_2(mytoPC_2), .ALUsrc(myALUsrc), .ForwardA(myForwardA), .ForwardB(myForwardB), .ALUop(myALUop),
						 .zero(myzero), .equal(Equal), .MemReadIDEX(IDEXmemread), .RegWriteEXMEM(EXMEMregwrite), .RegWriteMEMWB(MEMWBregwrite), .DataMemOut(myDataMemOut),
						 .RsIFID(IFIDrs), .RtIFID(IFIDrt), .RsIDEX(IDEXrs), .RtIDEX(IDEXrt), .RdEXMEM(EXMEMrd), .RdMEMWB(MEMWBrd), .opc(myopc), .func(myfunc));

	Controller My_Controller(.zero(myzero), .EqualFlag(Equal), .opc(myopc), .func(myfunc), .FlushFlag(Flush), .MemtoReg(myMemtoReg),
							 .toReg(mytoReg), .MemRead(myMemRead), .MemWrite(myMemWrite), .PCsrc(myPCsrc), .RegWrite(myRegWrite),
							 .Jal(myJal), .RegDst(myRegDst), .toPC_1(mytoPC_1), .toPC_2(mytoPC_2), .ALUsrc(myALUsrc), .ALUop(myALUop));
	
	HazardUnit My_HazardUnit(.IDEX_MemRead(IDEXmemread), .IDEX_Rt(IDEXrt), .IFID_Rs(IFIDrs), .IFID_Rt(IFIDrt), .PCwrite(PC_write), .IFIDwrite(IFID_write), .HazardSel(Hazard));
	
	ForwardUnit My_ForwardUnit(.EXMEM_RegWrite(EXMEMregwrite), .MEMWB_RegWrite(MEMWBregwrite), .IDEX_Rt(IDEXrt), .IDEX_Rs(IDEXrs),
							   .EXMEM_Rd(EXMEMrd), .MEMWB_Rd(MEMWBrd), .ForwardA(myForwardA), .ForwardB(myForwardB));
				
endmodule