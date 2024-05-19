.text
.globl main

# Main program
main:
    # Set up the stack pointer

    # Read the input integer
    li a7, 5              # System call number for ReadInt
    ecall                 # Perform system call to read the integer
    mv t0, a0             # Store the input integer in t0

    # Initialize counter in t1
    li t1, 0              # Counter for Fibonacci numbers less than the input
    li t2, 0              # Counter for stack in and out

    # Call recursive Fibonacci function with initial values F(0) = 0, F(1) = 1
    li a0, 0              # Fibonacci F(0)
    li a1, 1              # Fibonacci F(1)
    jal fibonacci        # Call the Fibonacci function

    # Output the result
    mv a0, t1             # Move the count to a0 for printing
    #mv a0, t2            The final program should have this instruction instead of the one in line23
    li a7, 1              # System call number for PrintInt
    ecall                 # Print the result

    # Exit the program
    li a7, 10             # System call number for exit
    ecall                 # Perform exit system call

# Recursive Fibonacci function
fibonacci:
    # Save return address to stack
    addi sp, sp, -4       # Decrement stack pointer to make space
    addi t2, t2, 1
    sw ra, 0(sp)          # Store return address on stack

    # Check if next Fibonacci number is >= input
    bge a1, t0, cleanup   # If F(n) >= input, cleanup and return

    # Increment counter since a0 is a valid Fibonacci number
    addi t1, t1, 1

    # Prepare next Fibonacci number
    add a2, a0, a1        # Calculate next Fibonacci number F(n) = F(n-1) + F(n)
    mv a0, a1             # Update old Fibonacci number
    mv a1, a2             # Update current Fibonacci number

    # Recursive call
    jal fibonacci        # Recursive call

cleanup:
    # Restore return address from stack
    lw ra, 0(sp)          # Load return address from stack
    addi t2, t2, 1
    addi sp, sp, 4        # Increment stack pointer to remove address

    ret                   # Return from function

