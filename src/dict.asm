	# dict.asm
	# Code related to the dictionary.
	
	.globl	get_random_word
	.globl	load_dict
	
	.text
# Gets a random word at a specified length
# Params	$a0 = Address of word buffer
#		$a1 = Length of random word to retrieve
get_random_word:
	addi	$t0, $a1, 48
	sb	$t0, filename_buffer+19
	
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)			# 0($sp) = $ra
	sw	$a0, 4($sp)			# 4($sp) = Address of word buffer
	sw	$a1, 8($sp)			# 8($sp) = Length of words
	
	li	$a0, 26
	jal	next_int
	addi	$v0, $v0, 97
	sb	$v0, filename_buffer+20
	
	la	$a0, filename_buffer
	jal	open_file
	sw	$v0, 12($sp)			# 12($sp) = File descriptor
	
	move	$a0, $v0
	lw	$a1, 8($sp)
	jal	read_header
	
	move	$t3, $v0			# $t3 = Number of words
	move	$a0, $v0
	jal	next_int
	lw	$t0, 8($sp)			# $t0 = Length of words
	mul	$t1, $v0, $t0
	add	$t1, $t1, $t0			# $t1 = Starting position of random word
	
	mul	$t2, $t3, $t0			# $t2 = Size of all words (allocation)
	
	lw	$a0, 12($sp)			# Set $a0 = File descriptor
	lw	$t7, 4($sp)			# Set $t7 = Address of word buffer
	
	sub	$sp, $sp, $t2			# Allocate size of all words
	
	move	$a1, $sp
	move	$a2, $t2
	li	$v0, 14
	syscall
	
	add	$t1, $t1, $sp			# $t1 = Start of random word in dictionary
	li	$t4, 0				# $t4 = Iterator
get_random_word_loop:
	add	$t5, $t1, $t4
	lb	$t6, 0($t5)
	add	$t5, $t7, $t4
	sb	$t6, 0($t5)
	
	addi	$t4, $t4, 1
	
	blt	$t4, $t0, get_random_word_loop
	
	add	$sp, $sp, $t2			# Deallocate size of all words
	
	lw	$a0, 12($sp)
	jal	close_file
	
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	addi	$sp, $sp, 16
	
	jr	$ra
	
# Reads the header of a dictionary segment
# Params	$a0 = File descriptor
#		$a1 = Length of words in file
# Returns	$v0 = Number of words in dictionary segment
read_header:
	addi	$sp, $sp, -12
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	
	la	$a0, header_buffer
	li	$a1, 8
	jal	clr_mem
	
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	
	move	$a2, $a1
	la	$a1, header_buffer
	li	$v0, 14
	syscall
	
	la	$a0, header_buffer
	jal	parse_int
	
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	addi	$sp, $sp, 12
	
	jr	$ra
	
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
filename_buffer:
	.asciiz	"content/processed2/xx"
header_buffer:
	.space	8
dict_full_size:
	.word	0
word_size_counts:				# Word counts up to 25 letters long
	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
buffer:						# 1 MiB buffer, dictionary shouldn't be larger than this.
	.space	1048576
