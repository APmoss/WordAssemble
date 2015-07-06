	# Team Avengers Assemble
	# Assembled with MARS 4.5
	# Settings -> "Assemble all files in directory" = TRUE
	# Settings -> "Initialize Program Counter to global 'main' if defined" = TRUE
	
	# main.asm
	# Global entry point.
	
	.globl	main
	
	.text
main:
	la	$a0, data_prompt
	jal	print_str
	
	la	$a0, str1
	la	$a1, str2
	jal	str_cmp
	
	move	$a0, $v0
	jal	print_int		# Example- will print 1 if str1 = str2, 0 if not equal
	
	j	exit

exit:
	li	$v0, 10
	syscall
	
	
	.data
str1:
	.asciiz "String goes here"
str2:
	.asciiz "String goes here"
