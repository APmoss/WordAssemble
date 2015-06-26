	.globl str_cmp
	
	.text
str_cmp:
	move	$t0, $a0
	move	$t1, $a1
str_cmp_loop:
	lb	$t2, ($t0)
	lb	$t3, ($t1)
	
	seq	$t4, $t2, 0
	seq	$t5, $t3, 0
	add	$t6, $t4, $t5
	
	add	$t0, $t0, 1
	add	$t1, $t1, 1
	
	beq	$t6, 1, str_cmp_notequal
	beq	$t6, 2, str_cmp_equal
	
	bne	$t4, $t5, str_cmp_notequal
	j	str_cmp_loop
str_cmp_equal:
	li	$v0, 1
	jr	$ra
str_cmp_notequal:
	li	$v0, 0
	jr	$ra
