	.globl main
	
	.text
main:
	la	$a0, str1
	la	$a1, str2
	jal	str_cmp
	
	move	$a0, $v0
	li	$v0, 1
	syscall
	
	j	exit

exit:
	li	$v0, 10
	syscall
	
	
	.data
str1:
	.asciiz "String goes here"
str2:
	.asciiz "String Goes here"

	
	.include "utils.asm"
