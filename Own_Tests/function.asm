_start:
    lui t0, 0x1F000  
    auipc t1, 0x0F0
    jal ra, test_jal
test_jalr:
    jalr ra, t2, 0
test_jal:
    addi t2, t1, 100
    addi t2, t2, -100
    jal ra, test_jalr