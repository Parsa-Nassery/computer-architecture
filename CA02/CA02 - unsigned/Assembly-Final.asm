findmax:

	;//R20: number :عددی خوانده شده از حاقظه
	;//R21: index : شماره خانه ی خوانده شده
	;//R22: last index of array : آخرین شماره خانه آرایه
	;//R23: slt result : slt نتیجه ی
	;//R25; max : بزرگ ترین
	;//R26; index of max number : شماره ی خانه ی بزرگ ترین عدد
	
			add R26, R0, R0;
			add R21, R0, R0;
			addi R22, R0, 20;
			lw R25, 1000(R21);
			add R26, R0, R21;
			addi R21, R21, 1;
Loop:		beq R21, R22, 7;
			lw R20, 1000(R21);
			slt R23, R25, R20;
			beq R0, R23, 2;
			add R25, R0, R20;
			add R26, R0, R21;
NotMax:		addi R21, R21, 1;
			J Loop;
End-Loop: 	sw R25, 2000(R0);
			sw R26, 2004(R0);
	
			Jr R31;