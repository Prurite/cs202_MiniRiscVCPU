.text
	li a0, 0x0000D728	# a0: the floating point
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
	li a7, 10	# exit
	ecall
