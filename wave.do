onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips/clk
add wave -noupdate /mips/rst
add wave -noupdate /mips/pc
add wave -noupdate /mips/im0/im
add wave -noupdate /mips/instr
add wave -noupdate /mips/AluOut
add wave -noupdate -expand /mips/gpr0/register
add wave -noupdate /mips/dm0/dm
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
WaveRestoreZoom {1416 ns} {2400 ns}
view wave 
wave clipboard store
wave create -pattern none -portmode input -language vlog /mips/clk 
wave create -pattern none -portmode input -language vlog /mips/rst 
wave modify -driver freeze -pattern repeater -initialvalue 1 -period 500ns -sequence { 0  } -repeat never -starttime 0ms -endtime 1ms Edit:/mips/rst 
wave modify -driver freeze -pattern clock -initialvalue 0 -period 100ns -dutycycle 50 -starttime 0ms -endtime 1ms Edit:/mips/clk 
WaveCollapseAll -1
wave clipboard restore
