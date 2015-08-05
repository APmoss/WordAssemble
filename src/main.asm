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
	jal	init_rng
	# Other initialization logic goes here
	
menu:
	jal	clrscr
	la	$a0, main_menu_prompt
	jal	println_str
	jal	endl

menu_selection:
	jal	read_int
	
	beq	$v0, 1, start_new_game
	#beq	$v0, 2, high_scores
	beq	$v0, 3, goodbye
	beq	$v0, 9, debug_menu
	
	la	$a0, data_invalid
	jal	println_str
	
	j	menu_selection
	
debug_menu:
	jal	clrscr
	la	$a0, debug_menu_prompt
	jal	println_str
	jal	endl
	
debug_menu_selection:
	jal	read_int
	
	#beq	$v0, 1, new_high_score
	beq	$v0, 2, new_random_number
	beq	$v0, 3, menu
	
	la	$a0, data_invalid
	jal	println_str
	
	j	debug_menu_selection
	
new_random_number:
	jal	clrscr
	la	$a0, new_random_number_prompt
	jal	print_str
	jal	read_int
	
	beq	$v0, -1, menu
	
	move	$a0, $v0
	jal	next_int
	move	$a0, $v0
	jal	println_int
	jal	read_char
	
	j	new_random_number
	
goodbye:
	jal	endl
	la	$a0, goodbye_message
	jal	println_str
	
	j	exit

exit:
	li	$v0, 10
	syscall

	
	.data
test:
	.asciiz	"123456"
main_menu_prompt:
	.asciiz	"Welcome to WordAssemble! Select an option to begin-\n1) New Game\n3) Exit\n9) Debug Tools"
debug_menu_prompt:
	.asciiz	"Select a debug test-\n2) Get a random number\n3) Return to main menu"
new_random_number_prompt:
	.asciiz	"Enter the upper bound of the random number, or -1 to return to the main menu: "
goodbye_message:
	.asciiz	"Thanks for playing WordAssemble. Goodbye!"
