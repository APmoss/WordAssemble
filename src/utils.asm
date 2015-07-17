	# utils.asm
	# Shared routines and utilities to simplify code.
	
	.globl	print_int
	.globl	println_int
	.globl	print_str
	.globl	println_str
	.globl	read_int
	.globl	endl
	.globl	clrscr
	.globl	str_cmp
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
buffer:
	.space	1
