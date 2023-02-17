
module LinearRegressor(input clk, rst, start, output [19:0] Vect_E, output ready);
	wire [19:0] Xi, Yi, B0, B1;
	wire [15:0] M;
	wire En_x2, En_xx, En_xy, En_x, En_y, En_x_y, En_b0, En_b1, En_err, Ld_1, Ld_2, cnt_1, cnt_2, Co1, Co2;

	Controller CTRL(.clk(clk), .rst(rst), .Start(start), .Cout1(Co1), .Cout2(Co2), .m(M), .Ready(ready), .en_x2(En_x2), .en_xx(En_xx), .en_xy(En_xy), .en_x(En_x), .en_y(En_y), .en_x_y(En_x_y), .en_b0(En_b0), .en_b1(En_b1), .en_err(En_err), .ld_1(Ld_1), .ld_2(Ld_2), .cnt1(cnt_1), .cnt2(cnt_2));
	DataLoader DL(.clk(clk), .rst(rst), .cnt1(cnt_1), .cnt2(cnt_2), .ld_1(Ld_1), .ld_2(Ld_2), .xi(Xi), .yi(Yi), .Cout1(Co1), .Cout2(Co2));
	CoCalculator CC(.clk(clk), .rst(rst), .en_x2(En_x2), .en_xx(En_xx), .en_xy(En_xy), .en_x(En_x), .en_y(En_y), .en_x_y(En_x_y), .en_b0(En_b0), .en_b1(En_b1), .xi(Xi), .yi(Yi), .m(M), .b0(B0), .b1(B1));
	ErrorChecker ECH(.clk(clk), .rst(rst), .en_err(En_err), .xi(Xi), .yi(Yi), .b1(B1), .b0(B0), .err(Vect_E));
endmodule
