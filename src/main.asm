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
	# Other initialization logic goes here
	
menu:
	jal	clrscr
	la	$a0, main_menu_prompt
	jal	println_str
	jal	endl

menu_selection:
	jal	read_int
	
	beq	$v0, 1, start_new_game
	beq	$v0, 2, high_scores
	beq	$v0, 3, goodbye
	beq	$v0, 9, debug_menu
	
	la	$a0, data_invalid
	jal	println_str
	
	j	menu_selection
	
	# Testing, ignore
	#la	$a0, data_testFile_path
	#la	$a0, data_words_path
	#jal	open_file
	
	#move	$a0, $v0
	#jal	load_dict
	
debug_menu:
	jal	clrscr
	la	$a0, debug_menu_prompt
	jal	println_str
	jal	endl
	
debug_menu_selection:
	jal	read_int
	
	beq	$v0, 1, new_high_score
	beq	$v0, 3, menu
	
	la	$a0, data_invalid
	jal	println_str
	
	j	debug_menu_selection
	
goodbye:
	jal	endl
	la	$a0, goodbye_message
	jal	println_str
	
	j	exit

exit:
	li	$v0, 10
	syscall

	
	.data
main_menu_prompt:
	.asciiz	"Welcome to WordAssemble! Select an option to begin-\n1) New Game\n2) High Scores\n3) Exit\n9) Debug Tools"
debug_menu_prompt:
	.asciiz	"Select a debug test-\n1) New High Score entry\n3) Return to main menu"
goodbye_message:
	.asciiz	"Thanks for playing WordAssemble. Goodbye!"
