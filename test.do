onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/mips0/clk
add wave -noupdate /testbench/mips0/rst
add wave -noupdate /testbench/mips0/pc
add wave -noupdate /testbench/mips0/im0/im
add wave -noupdate /testbench/mips0/instr
add wave -noupdate /testbench/mips0/AluOut
add wave -noupdate /testbench/mips0/RegWrite
add wave -noupdate /testbench/mips0/writereg
add wave -noupdate /testbench/mips0/writedata
add wave -noupdate /testbench/mips0/overflow
add wave -noupdate /testbench/mips0/alu0/A
add wave -noupdate /testbench/mips0/alu0/B
add wave -noupdate /testbench/mips0/alu0/AluCtrl
add wave -noupdate /testbench/mips0/alu0/over
add wave -noupdate /testbench/mips0/gpr0/register
add wave -noupdate /testbench/mips0/dm0/dm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 106
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {984 ns}
view wave 
wave clipboard store
WaveCollapseAll -1
wave clipboard restore
