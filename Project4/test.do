onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/u_mc/u_mips/clk
add wave -noupdate /testbench/u_mc/u_mips/rst
add wave -noupdate /testbench/u_mc/u_mips/instrR
add wave -noupdate /testbench/u_mc/u_mips/u_ctrl/state
add wave -noupdate /testbench/u_mc/u_mips/u_ctrl/PCWr
add wave -noupdate /testbench/u_mc/u_mips/u_ctrl/npcSel
add wave -noupdate /testbench/u_mc/u_mips/u_ctrl/IRWr
add wave -noupdate /testbench/u_mc/u_mips/u_ctrl/GPRWr
add wave -noupdate /testbench/u_mc/u_mips/u_ctrl/zero
add wave -noupdate /testbench/u_mc/u_mips/WDsel
add wave -noupdate /testbench/u_mc/u_mips/writeReg
add wave -noupdate /testbench/u_mc/u_mips/wd
add wave -noupdate /testbench/u_mc/u_mips/pc
add wave -noupdate /testbench/u_mc/u_mips/npc
add wave -noupdate /testbench/u_mc/u_mips/u_npc/pcp4
add wave -noupdate /testbench/u_mc/u_mips/AluOutR
add wave -noupdate /testbench/u_mc/u_mips/u_alu/A
add wave -noupdate /testbench/u_mc/u_mips/u_alu/B
add wave -noupdate /testbench/u_mc/u_mips/u_rf/register
add wave -noupdate /testbench/u_mc/u_mips/u_cp0/SR
add wave -noupdate /testbench/u_mc/u_mips/u_cp0/CAUSE
add wave -noupdate /testbench/u_mc/u_bridge/DEVTimer_IRQ
add wave -noupdate /testbench/u_mc/u_timer/ctrl
add wave -noupdate /testbench/u_mc/u_timer/preset
add wave -noupdate /testbench/u_mc/u_timer/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {274 ns} 0}
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
WaveRestoreZoom {0 ns} {862 ns}
