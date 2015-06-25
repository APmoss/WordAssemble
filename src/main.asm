	.globl main
	
	.text
main:
	la	$a0, str1
	la	$a1, str2
	jal	str_cmp
	
	j	exit

exit:
	li	$v0, 10
	syscall
	
	.include "utils.asm"
	
	
	.data
prompt:
	.asciiz "Hello"
str1:
	.asciiz "Test"
str2:
	.asciiz "Test"