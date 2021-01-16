onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /median_filter_tb/prev_row
add wave -noupdate -radix unsigned /median_filter_tb/curr_row
add wave -noupdate -radix unsigned /median_filter_tb/next_row
add wave -noupdate -radix unsigned -childformat {{/median_filter_tb/filtered_row(4) -radix unsigned} {/median_filter_tb/filtered_row(3) -radix unsigned} {/median_filter_tb/filtered_row(2) -radix unsigned} {/median_filter_tb/filtered_row(1) -radix unsigned} {/median_filter_tb/filtered_row(0) -radix unsigned}} -expand -subitemconfig {/median_filter_tb/filtered_row(4) {-radix unsigned} /median_filter_tb/filtered_row(3) {-radix unsigned} /median_filter_tb/filtered_row(2) {-radix unsigned} /median_filter_tb/filtered_row(1) {-radix unsigned} /median_filter_tb/filtered_row(0) {-radix unsigned}} /median_filter_tb/filtered_row
add wave -noupdate /median_filter_tb/correct
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {21 ns}
