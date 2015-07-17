	# Team Avengers Assemble
	# Assembled with MARS 4.5
	# Settings -> "Assemble all files in directory" = TRUE
	# Settings -> "Initialize Program Counter to global 'main' if defined" = TRUE
	
	# main.asm
	# Global entry point.
	
	.globl	main
	.globl	menu
	
	.text
main:
	jal	clrscr
	# Other initialization logic goes here
	
menu:
	la	$a0, data_welcome
	jal	println_str

menu_selection:
	jal	read_int
	
	beq	$v0, 1, start_new_game
	beq	$v0, 2, high_scores
	beq	$v0, 3, goodbye
	
	la	$a0, data_invalid
	jal	println_str
	
	j	menu_selection
	
	# Testing, ignore
	#la	$a0, data_testFile_path
	#la	$a0, data_words_path
	#jal	open_file
	
	#move	$a0, $v0
	#jal	load_dict
	
goodbye:
	jal	endl
	la	$a0, data_goodbye
	jal	println_str
	
	j	exit

exit:
	li	$v0, 10
	syscall
