	# game.asm
	# Code related to the game logic itself.
	
	.globl	start_new_game
	.globl 	word_buffer
	
	.text
start_new_game:
	li $a0, 64
	li $a1, 400
	li $a2, 114
	li $a3, 100
	li $v0, 31
	syscall
	syscall
	syscall
	li $a0, 72
	li $a1, 400
	li $a2, 10
	li $a3, 100
	li $v0, 31
	syscall
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
	
	la	$a0, word_buffer
	jal	get_anagrams
	sw	$v0, anagram_list_ptr
	sw	$v1, anagram_size_count_ptr
	
	la	$a0, word_buffer
	jal	scramble_word
	
	j	game_menu
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
	jal	gui
	jal	gui_letters
	
game_menu_selection:
	jal	read_int
	
	beq	$v0, 1, rearrange
	beq	$v0, 2, guess_word
	beq	$v0, 3, show_remaining
	beq	$v0, 4, quit_check
	
	la	$a0, data_invalid
	jal	println_str
	
	j	game_menu_selection
	
rearrange:
	jal	clrscr
rearrange_get:
	la	$a0, guess_word_buffer
	li	$a1, 16
	jal	clr_mem
	
	la	$a0, rearrange_message
	jal	print_str
	la	$a0, word_buffer
	jal	println_str
	la	$a0, guess_word_buffer
	li	$a1, 13
	jal	read_str
	
	la	$a0, guess_word_buffer
	jal	str_len
	li	$t0, 0
	sb	$t0, guess_word_buffer+-1($v0)
	
	la	$a0, guess_word_buffer
	la	$a1, word_buffer
	jal	str_isAnagram
	
	beq	$v0, 1, rearrange_valid
	
	la	$a0, rearrange_invalid
	jal	println_str
	jal	endl
	
	j	rearrange_get
rearrange_valid:
	la	$a0, guess_word_buffer
	la	$a1, word_buffer
	jal	str_cpy
	
	j	game_menu
	
guess_word:
	la	$a0, guess_word_prompt
	jal	print_str
	la	$a0, guess_word_buffer
	li	$a1, 13
	jal	read_str
	jal	clrscr
	
	j	check_word
	
check_word:
	la	$a0, guess_word_buffer
	jal	str_len
	li	$t0, 0
	sb	$t0, guess_word_buffer+-1($v0)
	
	la	$a0, compare_word_buffer
	li	$a1, 8
	jal	clr_mem
	
	li	$t0, 0				# $t0 = Iterator
	lw	$t1, anagram_list_ptr		# $t1 = Address of anagram list
	move	$t4, $t1			# $t4 = Starting position of current word we are inspecting
check_word_loop:
	add	$t2, $t1, $t0			# $t2 = Current address position inside anagram list
	lb	$t3, 0($t2)			# $t3 = Letter we are inspecting
	
	addi	$t0, $t0, 1
	
	beq	$t3, '\n', check_word_cmp
	beq	$t3, 0, check_word_cmp
	beq	$t3, '_', check_word_spec
	
	sub	$t5, $t2, $t4			# $t5 = Step of current word we are processing
	sb	$t3, compare_word_buffer($t5)
	
	j	check_word_loop
check_word_cmp:
	addi	$sp, $sp, -20
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)
	
	la	$a0, guess_word_buffer
	la	$a1, compare_word_buffer
	jal	str_cmp
	
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	lw	$t4, 16($sp)
	addi	$sp, $sp, 20
	
	beq	$v0, 1, check_word_correct
	
	addi	$t4, $t2, 1
	
	beq	$t3, 0, word_incorrect
	
	j	check_word_loop
check_word_correct:
	move	$a0, $t4
	sub	$a1, $t2, $t4
	li	$a2, '_'
	jal	fill_mem
	
	j	word_correct
check_word_spec:
	addi	$t4, $t2, 1
	
	j	check_word_loop
	
word_correct:
	# play a sound
	li $a0, 72
	li $a1, 400
	li $a2, 10
	li $a3, 100
	li $v0, 31
	syscall
	la	$a0, guess_word_buffer
	jal	str_len
	
	addi	$sp, $sp, -4
	sw	$v0, 0($sp)			# 0($sp) = Length of word guessed
	
	lw	$t0, current_score
	add	$t0, $t0, $v0
	sw	$t0, current_score		# Update score
	
	lw	$t0, anagram_size_count_ptr
	add	$t0, $t0, $v0
	lb	$t1, 0($t0)
	subi	$t1, $t1, 1
	sb	$t1, 0($t0)			# Subtract a count of the word's length
	
	la	$a0, word_correct_message
	jal	println_str
	
	lw	$a0, 0($sp)
	jal	print_int
	la	$a0, points_added
	jal	println_str
	
	addi	$sp, $sp, 4
	
	la	$a0, data_press_to_continue
	jal	println_str
	jal	read_char
	
	j	game_menu
	
word_incorrect:
	# play sound
	li $a0, 55
	li $a1, 400
	li $a2, 35
	li $a3, 100
	li $v0, 31
	syscall
	la	$a0, word_incorrect_message
	jal	println_str
	la	$a0, data_press_to_continue
	jal	println_str
	jal	read_char
	
	j	game_menu
	
show_remaining:
	jal	clrscr
	la	$a0, remaining_message
	jal	println_str
	
	li	$t0, 2
	lw	$t1, anagram_size_count_ptr
show_remaining_loop:
	move	$a0, $t0
	jal	print_int
	la	$a0, letter_words
	jal	print_str
	add	$t2, $t1, $t0
	lb	$a0, 0($t2)
	jal	println_int
	
	addi	$t0, $t0, 1
	
	ble	$t0, 7, show_remaining_loop
	
	la	$a0, data_press_to_continue
	jal	println_str
	jal	read_char
	
	j	game_menu
	
quit_check:
	li $a0, 72
	li $a1, 200
	li $a2, 48
	li $a3, 100
	li $v0, 31
	syscall
	syscall
	li $a0, 55
	li $a1, 400
	li $a2, 48
	li $a3, 100
	li $v0, 31
	syscall
	
	jal	clrscr
	la	$a0, quit_message
	jal	println_str
	jal	endl
	jal	read_int
	
	beq	$v0, 1, reveal
	beq	$v0, 2, game_menu
	
	jal	endl
	la	$a0, data_invalid
	jal	println_str
	
	j	quit_check
	
reveal:
	jal	clrscr
	lw	$a0, anagram_list_ptr
	jal	println_str
	jal	endl
	
	la	$a0, reveal_message
	jal	print_str
	lw	$a0, current_score
	jal	print_int
	jal	endl
	la	$a0, data_press_to_continue
	jal	println_str
	jal	read_char
	
	j	menu

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
	.asciiz	"What would you like to do?\n1) Rearrange the word\n2) Guess a word\n3) Show remaining word sizes\n4) Complete / Give up"
guess_word_prompt:
	.asciiz	"Enter your word to guess: "
word_correct_message:
	.asciiz	"That word is correct!"
points_added:
	.asciiz	" points have been added."
word_incorrect_message:
	.asciiz	"That word is not correct, or has been entered already."
quit_message:
	.asciiz	"Are you sure you want to end and show all answers?\n1) Yes\n2) No"
reveal_message:
	.asciiz	"These are some words you may have missed. Ones you got correct have been replaced by underscores.\nFinal score: "
remaining_message:
	.asciiz	"Remaining solutions-"
letter_words:
	.asciiz	" letter words: "
rearrange_message:
	.asciiz	"Enter your rearrangement of "
rearrange_invalid:
	.asciiz	"That is not a valid rearrangement. Please try again."
anagram_list_ptr:
	.word	0
anagram_size_count_ptr:
	.word	0
guess_word_buffer:
	.space	16
compare_word_buffer:
	.space	8
current_score:
	.word	0
word_buffer:
	.space	8
num_characters:
	.word	0
