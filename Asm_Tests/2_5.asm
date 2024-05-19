.text
.globl main

# Main program
main:
    # Read first 8-bit signed integer into a0
    li a7, 5             # System call for ReadInt
    ecall                # Read integer to a0
    mv a1, a0
    slli a1, a1, 24       # Align to 32-bit by left-shifting
    srli a1, a1, 24       # Sign-extend back to original position
    
    # Read second 8-bit signed integer into a1
    li a7, 5             # System call for ReadInt
    ecall                # Read integer to a1
    mv a2, a0
    slli a2, a2, 24       # Align to 32-bit by left-shifting
    srli a2, a2, 24       # Sign-extend back to original position

    # Perform addition
    add a3, a1, a2       # Add both numbers, result in a2

    # Handle overflow
    srli  a4, a3, 8        # Right-shift to  gain overflowed bits
    add a3, a3, a4       # Add overflow bits back to the original sum

    # Bitwise negate the result
    not a3, a3           # Bitwise NOT operation on the sum
    slli a3, a3, 24
    srli a3, a3, 24

    # Print the result
    mv a0, a3
    li a7, 1             # System call for PrintInt
    ecall                # Print the result

    # Exit program
    li a7, 10            # System call for exit
    ecall                # Perform system call to exit

