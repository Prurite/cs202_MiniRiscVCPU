Case2_5:
    li a7, 5            # System call for reading an integer
    ecall               # a0 now contains the input integer
    mv t2, a0           # Store input number in t2 for comparison

    li t3, 1            # Initialize loop variable i = 1
    li t4, 0

loop_2_5:
    mv a0, t3           # Move i to a0
    jal fib_2_5             # Calculate fib(i), result in a0

    blt a0, t2, increment_2_5 # If fib(i) < input, continue loop
    addi a0, t3, -1     # Set a0 to i - 1 (correct value before exiting)
    li a7, 1            # System call for printing an integer
    ecall               # Print the result in a0
    mv t4, a0           # The stack counter
    ecall
    li a7, 10           # Exit program
    ecall

increment_2_5:
    addi t3, t3, 1      # Increment i
    j loop_2_5              # Jump back to start of loop

fib_2_5:
    li t1, 2
    blt a0, t1, base_case_2_5 # If a0 < 2, handle base cases directly

    addi sp, sp, -16   # Allocate stack frame for 3 items (return address, n, saved t1)
    addi t4, t4, 4
    sw ra, 0(sp)       # Save return address
    sw a0, 4(sp)       # Save current a0 (n)
    sw t1, 8(sp)       # Save t1

    addi a0, a0, -1    # Compute fib(n-1)
    jal fib_2_5            # Recursive call
    lw t1, 8(sp)       # Restore t1
    sw a0, 12(sp)      # Save result of fib(n-1) in the stack

    lw t0, 4(sp)       # Load original n
    addi a0, t0, -2    # Set a0 to n-2
    jal fib_2_5            # Recursive call for fib(n-2)
    lw t1, 8(sp)       # Restore t1 again

    lw t0, 12(sp)      # Load result of fib(n-1) from stack
    add a0, a0, t0     # a0 = fib(n-2) + fib(n-1)

    lw ra, 0(sp)       # Restore return address
    addi sp, sp, 16    # Deallocate stack frame
    addi t4, t4, 4
    jr ra              # Return to caller

base_case_2_5:
    li t1, 1
    beq a0, zero, zero_case_2_5  # if a0 is 0, jump to zero_case
    li a0, 1           # For fib(1) and fib(2), return 1
    jr ra              # Return to caller

zero_case_2_5:
    li a0, 0           # For fib(0), return 0
    jr ra              # Return to caller