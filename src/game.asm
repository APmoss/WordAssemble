	# game.asm
	# Code related to the game logic itself.
	
	.globl	start_new_game
	
	.text
start_new_game:
	jal	clrscr
	
characters_selection:
	la	$a0, characters_prompt
	jal	print_str
	jal	read_int
	
	blt	$v0, 5, invalid_characters
	bgt	$v0, 7, invalid_characters
	
	# TODO: Continue game stuff
	
	j	menu

invalid_characters:
	la	$a0, data_invalid
	jal	println_str
	jal	endl
	
	j	characters_selection


	.data
characters_prompt:
	.asciiz	"How many characters should the words be? (5 - 7): "
