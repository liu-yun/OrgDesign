onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/mips0/clk
add wave -noupdate /testbench/mips0/rst
add wave -noupdate /testbench/mips0/instrR
add wave -noupdate /testbench/mips0/ctrl0/state
add wave -noupdate /testbench/mips0/ctrl0/PCWr
add wave -noupdate /testbench/mips0/ctrl0/NpcSel
add wave -noupdate /testbench/mips0/ctrl0/IRWr
add wave -noupdate /testbench/mips0/ctrl0/GPRWr
add wave -noupdate /testbench/mips0/ctrl0/zero
add wave -noupdate /testbench/mips0/WDsel
add wave -noupdate /testbench/mips0/writereg
add wave -noupdate /testbench/mips0/wd
add wave -noupdate /testbench/mips0/ifu0/pc
add wave -noupdate /testbench/mips0/ifu0/npc
add wave -noupdate /testbench/mips0/ifu0/npc0/pcp4
add wave -noupdate /testbench/mips0/AluOutR
add wave -noupdate /testbench/mips0/alu0/A
add wave -noupdate /testbench/mips0/alu0/B
add wave -noupdate /testbench/mips0/U_RF/register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5091 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
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
WaveRestoreZoom {11182 ns} {12044 ns}
