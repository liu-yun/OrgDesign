ori $16, $0, 1
ori $17, $0, 3
ori $8, $0, 1
ori $12, $0,0x5678
ori $13, $0,0x9abc
start:addu $4, $0,$16
addu $5, $0,$8
jal newadd
addu $16, $0, $2
subu $17,$17,$8
beq $16, $17, start
ori $8, $0,4
addi $9, $0, 4
addiu $10, $0, -8
start2:sw $12, 0($8)
lb $14, 1($8)
sb $13,7($8)
lw $15,4($8)
sb $14, -3($8)
lb $18, -1($8)
addu $4,$0,$8
addu $5,$0,$9
jal newadd
addu $8, $0, $2
slt $25,$10,$8
beq $25, $0,end2
subu $8, $10, $8
beq $8, $0, end1
lui $12, 65535
end1:ori $0, $0,1
lui $8, 5
lui $9, 50
start3:addu $4, $0, $8
addu $5, $0, $9
jal newadd
addu $8, $0, $2
addu $4, $0, $8
addu $5, $0, $9
jal newadd
addu $9, $0, $2
addu $9, $8, $9
subu $9, $9, $8
lui $10, 0x69
beq $9, $10, start4
beq $0, $0, start3
start4:j end
newadd:addu $2, $4, $5
jr $31
end2:addi $26,$0,0x12345678
end:

