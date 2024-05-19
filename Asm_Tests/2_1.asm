.text
.globl main

# Main program
main:
    li a7 5 # System call for ReadInt
    ecall
    # Assume the input 8-bit signed integer is in register a0
    # Extend the 8-bit number to 32 bits with sign extension
    slli a0, a0, 24   # Left shift the 8-bit number by 24 bits for extension
    srai a0, a0, 24   # Arithmetic right shift by 24 bits to restore position and extend sign

    # Call the custom clz function to calculate the number of leading zeros
    mv a1, a0        # Copy the extended integer to a1
    jal ra, clz      # Call clz function, result will be returned in a0

    # End the program (exit as an example)
    li a7, 1        # System call for PrintInt
    ecall            # Perform the system call
    
    li a7, 10      # System call for exit
    ecall

# Function to calculate the number of leading zeros in a 32-bit integer
# Input: a1 - 32-bit integer
# Output: a0 - number of leading zeros
clz:
    li a0, 32           # Initialize the result to 32
clz_loop:
    beqz a1, clz_done   # If a1 is 0, processing is complete
    srli a1, a1, 1     # Shift a1 right by t0 bits
    addi a0, a0, -1      # Update the count of leading zeros
    j clz_loop
clz_done:
    ret                 # Return to the caller
