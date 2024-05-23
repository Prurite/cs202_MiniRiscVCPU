.data
.text
addi sp, sp, -4
addi a0, x0, 1
addi a1, x0, 1
sw a0, 0(sp)
addi sp, sp, -4
sw a1, 0(sp)
addi t0, x0, 3

loop:
lw a0, 0(sp)
lw a1, 4(sp)
add a2, a0, a1
sw a2, -4(sp)
addi sp, sp, -4
addi t0, t0, -1
beqz t0, loop

lw a0, 0(sp)