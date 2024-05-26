Case3_1:
    li a1, 5
    li a2, 2
    sub a0, a1, a2

Case3_2:
    li a1, 5
    sw a1, -4(sp)
    lw a2, -4(sp)
    addi a2, a2, 7
    mv a0, a2

Case3_3:
    li t1, 17
    li t2, 6
    sub t3, t1, t2
    and t4, t1, t3
    xor a0, t3, t4
