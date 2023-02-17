onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /LinearRegressor/clk
add wave -noupdate /LinearRegressor/rst
add wave -noupdate /LinearRegressor/start
add wave -noupdate /LinearRegressor/Vect_E
add wave -noupdate /LinearRegressor/ready
add wave -noupdate /LinearRegressor/Xi
add wave -noupdate /LinearRegressor/Yi
add wave -noupdate /LinearRegressor/B0
add wave -noupdate /LinearRegressor/B1
add wave -noupdate /LinearRegressor/M
add wave -noupdate /LinearRegressor/En_x2
add wave -noupdate /LinearRegressor/En_xx
add wave -noupdate /LinearRegressor/En_xy
add wave -noupdate /LinearRegressor/En_x
add wave -noupdate /LinearRegressor/En_y
add wave -noupdate /LinearRegressor/En_x_y
add wave -noupdate /LinearRegressor/En_b0
add wave -noupdate /LinearRegressor/En_b1
add wave -noupdate /LinearRegressor/En_err
add wave -noupdate /LinearRegressor/Ld_1
add wave -noupdate /LinearRegressor/Ld_2
add wave -noupdate /LinearRegressor/cnt_1
add wave -noupdate /LinearRegressor/cnt_2
add wave -noupdate /LinearRegressor/Co1
add wave -noupdate /LinearRegressor/Co2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8196 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 182
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {7584 ps} {8400 ps}
