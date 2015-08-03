	# utils.asm
	# Shared routines and utilities to simplify code.
	
	.globl	print_int
	.globl	println_int
	.globl	print_str
	.globl	println_str
	.globl	read_int
	.globl	read_str
	.globl	read_char
	.globl	endl
	.globl	clrscr
	.globl	init_rng
	.globl	next_int
	.globl	str_cmp
	.globl	str_len
	.globl	str_rnl
	.globl	parse_int
	.globl	clr_mem
	.globl	fill_mem
	.globl	open_file
	.globl	close_file
	
	.text
# Prints a signed 32-bit integer to the console.
# Params	$a0 = Integer to print
print_int:
	li	$v0, 1
	syscall
	
	jr	$ra
	
# Prints a signed 32-bit integer and a newline to the console.
# Params	$a0 = Integer to print
println_int:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	jal	print_int
	jal	endl
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	
	jr	$ra
	
# Prints a null terminated string to the console.
# Params	$a0 = Address of string to print
print_str:
	li	$v0, 4
	syscall
	
	jr	$ra
	
# Prints a null terminated string and a newline to the console.
# Params	$a0 = Address of string to print
println_str:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	jal	print_str
	jal	endl
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	
	jr	$ra
	
# Reads an integer from the console.
# Returns	$v0 = Integer typed into console
read_int:
	li	$v0, 5
	syscall
	
	jr	$ra
	
# Reads a string from the console.
# Params	$a0 = Address of input buffer
#		$a1 = Max number of characters to read
read_str:
	li	$v0, 8
	syscall
	
	jr	$ra
	
# Reads a single key from the console.
# Returns	$v0 = ASCII key typed into console
read_char:
	li	$v0, 12
	syscall
	
	jr	$ra
	
# Prints a newline character ('\n') to the console
endl:
	lb	$a0, newline
	li	$v0, 11
	syscall
	
	jr	$ra
	
# "Clears" the console by printing 50 newlines. Close enough.
clrscr:
	la	$a0, clrscr_str
	
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	jal	print_str
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	
	jr	$ra
	
# Initializes the random number generator
init_rng:
	li	$v0, 30
	syscall
	move	$a1, $a0
	li	$a0, 0
	li	$v0, 40
	syscall
	
	jr	$ra
	
# Gets a random integer from 0 to the selected number.
# Params	$a0 = Maximum random number, exclusive
# Returns	$v0 = The generated random number
next_int:
	move	$a1, $a0
	li	$a0, 0
	li	$v0, 42
	syscall
	
	move	$v0, $a0
	
	jr	$ra
	
# Compares two null terminated strings.
# Params	$a0 = Address of string 1
#		$a1 = Address of string 2
# Returns	$v0 = 1 if identical, 0 if not identical
str_cmp:
	lbu	$t0, 0($a0)
	lbu	$t1, 0($a1)
	
	seq	$t2, $t0, 0
	seq	$t3, $t1, 0
	add	$t4, $t2, $t3
	
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	
	beq	$t4, 1, str_cmp_notequal
	beq	$t4, 2, str_cmp_equal
	
	bne	$t0, $t1, str_cmp_notequal
	j	str_cmp
str_cmp_equal:
	li	$v0, 1
	jr	$ra
str_cmp_notequal:
	li	$v0, 0
	jr	$ra
	
# Gets the number of characters in a string.
# Params	$a0 = Address of null terminated string
# Returns	$v0 = Number of characters in the string
str_len:
	li	$v0, 0
str_len_loop:
	add	$t0, $a0, $v0
	lb	$t1, 0($t0)
	
	beq	$t1, 0, str_len_ret
	
	addi	$v0, $v0, 1
	
	j	str_len_loop
str_len_ret:
	jr	$ra
	
# Removes newlines from a string, replacing it with a null terminator.
# Params	$a0 = Address of string to inspect
str_rnl:
	lb	$t0, 0($a0)
	beq	$t0, '\n', str_rnl_nl
	beq	$t0, 0, str_rnl_end
	
	addi	$a0, $a0, 1
	
	j	str_rnl
str_rnl_nl:
	li	$t0, 0
	sb	$a0, 0($t0)
	
	jr	$ra
str_rnl_end:
	jr	$ra
	
# Parses a string for an unsigned integer
# Params	$a0 = Address of null terminated string to parse
# Returns	$v0 = Number parsed from the string
parse_int:
	addi	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	
	jal	str_len
	move	$t0, $v0
	subi	$t1, $v0, 1
	li	$v0, 0
	
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	addi	$sp, $sp, 8
parse_int_loop:
	subi	$t0, $t0, 1
	
	bltz	$t0, parse_int_ret
	
	sub	$t2, $t1, $t0
	add	$t2, $t2, $a0
	lbu	$t3, 0($t2)
	
	andi	$t4, $t3, 0x0f
	
	mul	$v0, $v0, 10
	add	$v0, $v0, $t4
	
	j	parse_int_loop
parse_int_ret:
	jr	$ra
	
# Clears the memory address with zeroes.
# Params	$a0 = Address to start clearing
#		$a1 = Number of bytes to clear
clr_mem:
	li	$t0, 0
	add	$t1, $a0, $a1
clr_mem_loop:
	sb	$t0, 0($a0)
	addi	$a0, $a0, 1
	blt	$a0, $t1, clr_mem_loop
	
	jr	$ra
	
# Fills the memory address with a specified value
# Params	$a0 = Address to start filling
#		$a1 = Number of bytes to clear
#		$a2 = Value to fill bytes with
fill_mem:
	add	$t1, $a0, $a1
fill_mem_loop:
	sb	$a2, 0($a0)
	addi	$a0, $a0, 1
	blt	$a0, $t1, fill_mem_loop
	
	jr	$ra
	
# Opens file for reading.
# Params	$a0 = String of file path
# Returns	$v0 = File descriptor
open_file:
	li	$v0, 13
	li	$a1, 0				# Read
	li	$a2, 0				# Mode
	syscall
	
	jr	$ra
	
# Closes file gracefully.
# Params	$a0 = File descriptor to close
close_file:
	li	$v0, 16
	syscall
	
	jr	$ra


	.data
newline:
	.byte	'\n'
clrscr_str:
	.asciiz	"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
isSubset_buffer:
	.space	16
