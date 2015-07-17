	# dict.asm
	# Code related to the dictionary.
	
	.globl	load_dict
	
	.text
# Initializes dictionary routines.
# Params	$a0 = File descriptor of dictionary file
# Returns	$v0 = asd
load_dict:
	li	$v0, 14
	la	$a1, buffer
	li	$a2, 1048576
	
	syscall
	
	li	$t0, 0
	sw	$v0, dict_full_size
load_dict_count_loop:
	move	$t1, $t0
load_dict_count_loop_inner:
	addi	$t1, $t1, 1
	lb	$t2, buffer($t1)
	
	bne	$t2, '\n', load_dict_count_loop_inner
	
	sub	$t3, $t1, $t0				# Word size
	sll	$t3, $t3, 2				# Multiply time 4 so we can access word index
	lw	$t2, word_size_counts($t3)		# Add one to that word size count
	addi	$t2, $t2, 1
	sw	$t2, word_size_counts($t3)
	
	addi	$t0, $t1, 1
	blt	$t0, $v0, load_dict_count_loop
	
	# testing, ignore
	move	$t4, $ra
	jal	endl
	jal	endl
	lw	$a0, word_size_counts+0
	jal	println_int
	lw	$a0, word_size_counts+4
	jal	println_int
	lw	$a0, word_size_counts+8
	jal	println_int
	lw	$a0, word_size_counts+12
	jal	println_int
	lw	$a0, word_size_counts+16
	jal	println_int
	lw	$a0, word_size_counts+20
	jal	println_int
	lw	$a0, word_size_counts+24
	jal	println_int
	lw	$a0, word_size_counts+28
	jal	println_int
	lw	$a0, word_size_counts+32
	jal	println_int
	lw	$a0, word_size_counts+36
	jal	println_int
	
	move	$ra, $t4
	#asd
	
	jr	$ra

	.data
dict_full_size:
	.word	0
word_size_counts:				# Word counts up to 25 letters long
	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
buffer:						# 1 MiB buffer, dictionary shouldn't be larger than this.
	.space	1048576
