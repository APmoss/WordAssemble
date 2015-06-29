	.globl str_cmp
	.globl open_words_file
	
	.text
str_cmp:					# Compare two null terminated strings.
	move	$t0, $a0			# $a0, $a1 contains addresses of strings.
	move	$t1, $a1			# Returns 1 if identical, or 0 if not.
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

open_words_file:				# Opens word list file
	li	$v0, 13
	la	$a0, words_path			# File path
	li	$a1, 0				# Read
	li	$a2, 0				# Mode ignored
	syscall
	
	jr	$ra
	
close_words_file:				# Closes word list file
	li	$v0, 16				# $a0 should contain file descriptor.
	syscall
	
	jr	$ra
	
	.data
words_path:
	.asciiz	"content/words.txt"
