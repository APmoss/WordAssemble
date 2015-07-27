	# game.asm
	# Code related to the game logic itself.
	
	.globl	start_new_game
	
	.text
start_new_game:
	li	$t0, 0
	sw	$t0, current_score
	jal	clrscr
	
characters_selection:
	la	$a0, characters_prompt
	jal	print_str
	jal	read_int
	
	blt	$v0, 5, invalid_characters
	bgt	$v0, 7, invalid_characters
	
	sw	$v0, num_characters
	
	la	$a0, word_buffer
	li	$a1, 8
	jal	clr_mem
	
	la	$a0, word_buffer
	lw	$a1, num_characters
	jal	get_random_word
	
	# TODO Testing, remove
	la	$a0, word_buffer
	jal	println_str
	jal	read_char
	#
	
	la	$a0, word_buffer
	jal	scramble_word
	
	# TODO Testing, remove
	la	$a0, word_buffer
	jal	println_str
	jal	read_char
	#
	
game_menu:
	jal	clrscr
	la	$a0, current_word_text
	jal	print_str
	la	$a0, word_buffer
	jal	println_str
	la	$a0, current_score_text
	jal	print_str
	lw	$a0, current_score
	jal	println_int
	la	$a0, game_menu_prompt
	jal	println_str
	jal	endl
game_menu_selection:
	jal	read_int
	
	#beq	$v0, 1, rearrange
	#beq	$v0, 2, guess
	#beq	$v0, 3, quit
	
	la	$a0, data_invalid
	jal	println_str
	
	j	game_menu_selection

invalid_characters:
	la	$a0, data_invalid
	jal	println_str
	jal	endl
	
	j	characters_selection

# Shuffles the letters in a string of ASCII characters.
# Params	$a0 = Address of null-terminated string to scramble
scramble_word:
	li	$t0, 0
	
	addi	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)				# 4($sp) = Address of string
	
	jal	str_len
	move	$t2, $v0				# $t2 = Length of string
	lw	$t3, 4($sp)
	add	$t3, $t3, $t2
	subi	$t3, $t3, 1				# $t3 = Max to swap
scramble_word_loop:
	lw	$t1, 4($sp)				# $t1 = Address of byte we may swap
scramble_word_inner:
	li	$a0, 2
	jal	next_int
	
	beqz	$v0, scramble_word_swap
scramble_word_cont:
	addi	$t1, $t1, 1
	blt	$t1, $t3, scramble_word_inner
	
	addi	$t0, $t0, 1
	blt	$t0, 50, scramble_word_loop
	
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	addi	$sp, $sp, 8
	
	jr	$ra
scramble_word_swap:
	lb	$t4, 0($t1)				# $t4 = Temp1
	lb	$t5, 1($t1)				# $t5 = Address + 1
	
	sb	$t4, 1($t1)
	sb	$t5, 0($t1)
	
	j	scramble_word_cont


	.data
characters_prompt:
	.asciiz	"How many characters should the starting word be? (5 - 7): "
current_word_text:
	.asciiz	"Current word: "
current_score_text:
	.asciiz	"Current score: "
game_menu_prompt:
	.asciiz	"What would you like to do?\n1) Rearrange the word\n2) Guess a word\n3) Give up"
current_score:
	.word	0
word_buffer:
	.space	8
num_characters:
	.word	0
