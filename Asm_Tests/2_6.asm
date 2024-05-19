.text
.globl main

# Main program
main:
    # System call to read the first byte (lower 8 bits)
    li a7, 5              # ReadInt system call number
    ecall                 # Perform system call
    slli a0, a0, 20
    srli a0, a0, 20
    
    # Now a0 contains the 12-bit value in little endian

    # Extract bytes to swap them for big endian
    slli a1, a0, 24
    srli a1, a1, 24      # a1 stores the low 8 bits
    srli a2, a0, 8         # a2 stores the high 8 bits
    slli a1, a1, 8
    add a0, a1, a2

    # Output the result
    li a7, 1              # PrintInt system call number
    ecall                 # Perform system call to print

    # Exit program
    li a7, 10             # System call number for exit
    ecall                 # Perform exit system call
