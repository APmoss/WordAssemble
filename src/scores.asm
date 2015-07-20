	# scores.asm
	# Code related to the high scores of the game.
	
	.globl	high_scores
	.globl	new_high_score
		
	.text
high_scores:
	jal	clrscr
	# Not implemented
	la	$a0, data_press_any_key
	jal	print_str
	jal	read_char
	
	j	menu

# Prompts for name and writes to the high scores file with a new high score.
# Params	$a0 = Integer of score to write
new_high_score:
	move	$t0, $a0
	la	$a0, your_score
	jal	print_str
	move	$a0, $t0
	jal	println_int
	
	la	$a0, enter_name
	jal	print_str
	la	$a0, name_buffer
	li	$a1, 20
	jal	read_str
	
	# TODO: Write to file and stuff
	
	j	high_scores
	
	
	.data
your_score:
	.asciiz	"Your score: "
enter_name:
	.asciiz	"Please enter your name (max 20 characters): "
name_buffer:
	.space	20
