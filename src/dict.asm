	# dict.asm
	# Code related to the dictionary.
	
	.globl	get_random_word
	.globl	get_anagrams
	
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
	
# Gets all possible anagrams for a word.
# Params	$a0 = Address of word we are getting anagrams for
# Returns	$v0 = Address of anagram list
#		$v1 = Address of anagram count
get_anagrams:
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)			# 4($sp) = Address of word we are getting anagrams for
	
	la	$a0, anagrams_filename_buffer+17
	li	$a1, 8
	jal	clr_mem
	
	lw	$a0, 4($sp)
	jal	str_len
	li	$t0, 0				# $t0 = Iterator
	move	$t1, $v0			# $t1 = Length of word we are getting anagrams for
get_anagrams_loop:
	lw	$t2, 4($sp)
	add	$t2, $t2, $t0
	lb	$t3, 0($t2)
	la	$t4, anagrams_filename_buffer+17
	add	$t4, $t4, $t0
	sb	$t3, 0($t4)
	
	addi	$t0, $t0, 1
	blt	$t0, $t1, get_anagrams_loop
get_anagrams_file:
	li	$a0, 1024
	li	$v0, 9
	syscall					# Allocate 1k heap space
	
	sw	$v0, 8($sp)			# 8($sp) = Address of buffer to hold all anagrams
	
	la	$a0, anagrams_filename_buffer
	jal	open_file
	
	sw	$v0, 12($sp)
	
	move	$a0, $v0
	lw	$a1, 8($sp)
	li	$a2, 1024
	li	$v0, 14
	syscall
	
	lw	$a0, 12($sp)
	jal	close_file
count_anagrams:
	# TODO: clear anagrams_size_counts
	li	$t0, 0				# $t0 = Iterator
	lw	$t1, 8($sp)			# $t1 = Address of buffer to hold all anagrams
	move	$t4, $t1			# $t4 = Address of start of word currently counting
count_anagrams_loop:
	add	$t2, $t1, $t0
	lb	$t3, 0($t2)
	
	addi	$t0, $t0, 1
	
	beq	$t3, '\n', count_anagram
	beq	$t3, 0, count_anagram
	
	j	count_anagrams_loop
count_anagram:
	sub	$t5, $t2, $t4
	#todo remove subi	$t5, $t5, 1
	lb	$t6, anagram_size_counts($t5)
	addi	$t6, $t6, 1
	sb	$t6, anagram_size_counts($t5)
	addi	$t4, $t2, 1
	
	beq	$t3, 0, count_anagrams_end
	
	j	count_anagrams_loop
count_anagrams_end:
	lw	$v0, 8($sp)
	la	$v1, anagram_size_counts
	lw	$ra, 0($sp)
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


	.data
filename_buffer:
	.asciiz	"content/processed2/xx"
anagrams_filename_buffer:
	.asciiz	"content/anagrams/xxxxxxxx"
anagrams_word_buffer:
	.space	10
header_buffer:
	.space	8
anagram_size_counts:
	.byte	0, 0, 0, 0, 0, 0, 0, 0
