findmax:
	;// در خانه 3000 حافظه عدد 0 نوشته شده است
	;// در خانه 3001 حافظه عدد 000...100 نوشته شده است
	;//R1: همیشه صفر
	;//R2: number :عددی خوانده شده از حاقظه
	;//R3: index : شماره خانه ی عدد خوانده شده
	;//R4: عدد 000...100
	;//R6; max : بزرگ ترین
	;//R7; index of max number : شماره ی خانه ی بزرگ ترین عدد

initial:	Load 3000;
			MoveTo R1;
			MoveTo R3;
			MoveTo R7;
			Load 3001;
			MoveTo R4;
index0:		Load 1000;
			MoveTo R6;
index1:		MoveFrom R3;
			Addi 1;
			MoveTo R3;
			Load 1001;
			MoveTo R2;
			Sub R6;
			Not R0;
			And R4;
			BranchZ R1, index2;
			MoveFrom R2;
			MoveTo R6;
			MoveFrom R3;
			MoveTo R7;
index2:		MoveFrom R3;
			Addi 1;
			MoveTo R3;
			Load 1002;
			MoveTo R2;
			Sub R6;
			Not R0;
			And R4;
			BranchZ R1, index3;
			MoveFrom R2;
			MoveTo R6;
			MoveFrom R3;
			MoveTo R7;
index3:		...
			...
index19:	...
save:		MoveFrom R7;
			Store 4000;
			MoveFrom R6;
			Store 4001;