.text    
    li a7, 5
    ecall
    mv t1, a0
    ecall
    mv t2, a0
    li a7, 1
    mv a0, t1
    ecall
    mv a0, t2
    ecall