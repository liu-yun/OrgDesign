addi $t0,$0,0x0801 #000001_00000000_01
mtc0 $t0,$12

# base_sec $t2
# cnt_sec $t3
addi $t1,$0,0x00007f10	#switch
addi $t5,$0,0x00007f00	#timer
addi $t6,$0,0x00007f20	#led

addu $t3,$0,$0		#reset cnt_sec
lw $t2,0($t1)  		#base_sec
sw $t2,4($t6)		#current led

addi $s0,$0,10		#timer preset
sw $s0,4($t5)
addi $t0,$0,0x9   	#ctrl 1001
sw $t0,0($t5)

start:
lw $t4,0($t1)		#load switch
j start

.text 0x00004180
sw $s0,4($t5) 		#reset preset
beq $t2,$t4,cont
addu $t2,$t4,$0 	#update base_sec
addu $t3,$0,-1	    #reset cnt_sec
cont:
addi $t3,$t3,1		#cnt++
addu $s1,$t2,$t3	#base+cnt
sw $s1,4($t6) 		#current led
eret
