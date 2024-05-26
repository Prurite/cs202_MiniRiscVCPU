Start:
    li a7, 1
    li a0, 0xFFFFFFFF
    ecall
    li a7, 5
    ecall
    li t0, 1
    beq a0, t0, Case1_1     #1
    addi t0, t0, 1
    beq a0, t0, Case2_1     #2
    addi t0, t0, 1
    beq a0, t0, Case2_2     #3
    addi t0, t0, 1
    beq a0, t0, Case2_3     #4
    addi t0, t0, 1
    beq a0, t0, Case2_4     #5
    addi t0, t0, 1
    beq a0, t0, Case2_5     #6
    addi t0, t0, 1
    beq a0, t0, Case2_6     #7

Case1_1:
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

Case1_2:
    li a7, 5
    ecall
    li a7, 1
    ecall
    slli a0, a0, 24
    srai a0, a0, 24 #signed bit extension
    addi sp, sp, -4
    sw a0, 0(sp)

Case1_3:
    li a7, 5
    ecall
    li a7, 1
    ecall
    slli a0, a0, 24
    srai a0, a0, 24 #signed bit extension
    addi sp, sp, -4
    sw a0, 0(sp)

Case1_4:
    lw a2, 0(sp)
    addi sp, sp ,4
    lw a1, 0(sp)
    addi sp, sp, 4
    li a7, 1
    beq a1, a2, Case1_5
    li a0, 0xA0000000
    ecall
    j Case1_5
light_beq:
    li a0, 0xA0000001
    ecall
    j Case1_5



Case1_5:
    blt a1, a2, light_blt
    li a0, 0xB0000000
    ecall
    j Case1_6
light_blt:
    li a0, 0xB0000001
    ecall
    j Case1_6


Case1_6:
    bge a1, a2, light_bge
    li a0, 0xC0000000
    ecall
    j Case1_7
light_bge:
    li a0, 0xC000001
    ecall
    j Case1_7


Case1_7:
    bltu a1, a2, light_bltu
    li a0, 0xD0000000
    ecall
    j Case1_8
light_bltu:
    li a0, 0xD0000001
    ecall
    j Case1_8


Case1_8:
    bgeu a1, a2, light_bgeu
    li a0, 0xE0000000
    ecall
    j out
light_bgeu:
    li a0, 0xE0000001
    ecall
    j out


Case2_1:
    li a7 5 # System call for ReadInt
    ecall
    andi a0, a0, 0x000000FF # low 8 bits

    # Call the custom clz function to calculate the number of leading zeros
    mv a1, a0        # Copy the extended integer to a1
    jal ra, clz      # Call clz function, result will be returned in a0

    # End the program (exit as an example)
    li a7, 1        # System call for PrintInt
    ecall
    
    j out     # exit
clz:
    li a0, 8           # Initialize the result to 8
clz_loop:
    beqz a1, clz_done   # If a1 is 0, processing is complete
    srli a1, a1, 1     # Shift a1 right by 1 bits
    addi a0, a0, -1      # Update the count of leading zeros
    j clz_loop
clz_done:
    ret                 # Return to the caller


Case2_2:
    li a7, 5
    ecall	            
    slli t0, a0, 8
    ecall
    or a0, a0, t0               # a0: the floating point
	srli s0, a0, 15		# s0: sign bit
	srli a1, a0, 10
	andi a1, a1, 0x1f	# a1: biased exp
	addi a1, a1, -15	# a1: exp
	andi a2, a0, 0x03ff	# a2: mantissa
	ori a2, a2, 0x0400	# a2: full mantissa
		
	# Check exp
	li t0, 10
	bge a1, t0, no_fraction
	
	# Get integer and fractional parts
	li t1, 10
	sub t1, t1, a1		# t1: shift right amount (10 - exp)
	srl t2, a2, t1		# t2: integer part
	sll t3, t2, t1		# t3: reconstruct integer part
	sub t4, a2, t3		# t4: fractional part
	
	# Round
	li t5, 1
	addi t1, t1, -1		# t1: 1 << t1 is 0.5
	sll t5, t5, t1
	mv a3, t2			# a3: rounded result
	blt t4, t5, round_down
	addi a3, a3, 1
round_down:
	
	# Floor
	sgtz t5, t4			# t5: has fractional part
	and t5, s0, t5		# t5: has frac & is negative
	add a4, t2, t5		# t5 true: add 1 to the abs of floored value
	
	# Ceil
	sgtz t5, t4			# t5: has fractional part
	xori t6, s0, 1		# t6: is positive
	and t5, t5, t6		# t5: has frac & is positive
	add a5, t2, t5		# t5 true: add 1 to the ceiled value
	j apply_sign

no_fraction:
	li t1, 10
	sub t1, a1, t1		# t1: shift left amount (exp - 10)
	sll t2, a2, t1		# t2: integer part
	mv a3, t2
	mv a4, t2
	mv a5, t2
	
apply_sign:
	beqz s0, done
	neg a3, a3			# a3: rounded result
	neg a4, a4			# a4: floored result
	neg a5, a5			# a5: ceiled result
		
done:
    li a7, 1
    mv a0, a4
    ecall
    mv a0, a5
    ecall
    mv a0, a3
    ecall
    j out


Case2_3:
    # Read first 8-bit signed integer into a0
    li a7, 5             # System call for ReadInt
    ecall                # Read integer to a0
    mv a1, a0
    
    # Read second 8-bit signed integer into a1
    li a7, 5             # System call for ReadInt
    ecall                # Read integer to a1
    mv a2, a0

    # Perform addition
    add a3, a1, a2       # Add both numbers, result in a3

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
    j out            # exit

Case2_4:
    li a7, 5              
    ecall                 
    mv a1, a0
    ecall
    slli a0, a0, 8
    or a1, a1, a0
    mv a0, a1

    # Output the result
    li a7, 1              # PrintInt system call number
    ecall                 # Perform system call to print

    # Exit
    j out

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
    j out           # Exit program

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


Case2_6:
    li a7, 5            # System call for reading an integer
    ecall               # a0 now contains the input integer
    mv t2, a0           # Store input number in t2 for comparison

    li t3, 1            # Initialize loop variable i = 1

loop_2_6:
    mv a0, t3           # Move i to a0
    jal fib_2_6             # Calculate fib(i), result in a0

    blt a0, t2, increment_2_6 # If fib(i) < input, continue loop
    addi a0, t3, -1     # Set a0 to i - 1 (correct value before exiting)
    li a7, 1            # System call for printing an integer
    ecall               # Print the result in a0
    j out           # Exit program

increment_2_6:
    addi t3, t3, 1      # Increment i
    j loop_2_6              # Jump back to start of loop

fib_2_6:
    li t1, 2
    blt a0, t1, base_case_2_6 # If a0 < 2, handle base cases directly

    addi sp, sp, -16   # Allocate stack frame for 3 items (return address, n, saved t1)
    sw ra, 0(sp)       # Save return address
    li a7, 1
    mv t4, a0
    mv a0, ra
    ecall
    mv a0, t4
    sw a0, 4(sp)       # Save current a0 (n)
    ecall
    sw t1, 8(sp)       # Save t1
    mv t4, a0
    mv a0, t1
    ecall
    mv a0, t4
    addi a0, a0, -1    # Compute fib(n-1)
    jal fib_2_6            # Recursive call
    lw t1, 8(sp)       # Restore t1
    sw a0, 12(sp)      # Save result of fib(n-1) in the stack
    ecall
    lw t0, 4(sp)       # Load original n
    addi a0, t0, -2    # Set a0 to n-2
    jal fib_2_6            # Recursive call for fib(n-2)
    lw t1, 8(sp)       # Restore t1 again

    lw t0, 12(sp)      # Load result of fib(n-1) from stack
    add a0, a0, t0     # a0 = fib(n-2) + fib(n-1)

    lw ra, 0(sp)       # Restore return address
    addi sp, sp, 16    # Deallocate stack frame
    jr ra              # Return to caller

base_case_2_6:
    li t1, 1
    beq a0, zero, zero_case_2_6  # if a0 is 0, jump to zero_case
    li a0, 1           # For fib(1) and fib(2), return 1
    jr ra              # Return to caller

zero_case_2_6:
    li a0, 0           # For fib(0), return 0
    jr ra              # Return to caller


out:
j Start
