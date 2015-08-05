# Open Bitmap Display from Tools Menu
# Set Unit Width in Pixels to 16
# Set Unit Height in Pixels to 16
# Set Display Width in Pixels to 512
# Set Display Height in Pixels to 512
# Set Base Address for Display to 0x10008000 ($gp)
.globl gui
.globl gui_letters
.data
# color 0x00RRGGBB
white: 		.word 0x00FFFFFF
blue: 		.word 0x000000FF
green:		.word 0x0000FF00
red:		.word 0x00FF0000
width:		.half 32
height:		.half 32

.text
gui:
	or $t1, $ra, $zero	# preserve $ra
	lw $s6, blue	# set border color
	lw $s7, white	# set background color
	move $a0, $s7
	jal Memory	# paint background
	jal Borders	# paint borders
	sw $a0, ($a1)
	jal Banner
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
Memory:
	lh $a1, width	# get width
	lh $a2, height	# get height
	multu $a1, $a2	# calculate matrix size
	mflo $a2	
	sll $a2, $a2, 2	# multiply by 4
	add $a2, $a2, $gp # add global pointer address to upper bound
	move $a1, $gp	# get lower bound
	
Memory_sub:	
	sw $a0, ($a1)	# store address
	add $a1, $a1, 4	# move to next cell
	blt $a1, $a2, Memory_sub
	
Paint:
	sw $a0, ($a1)	# store cell address, paints cell
	jr $ra			
	
Borders:
	lh $a1, width
	sll $a1, $a1, 2	
	add $a2, $a1, $gp
	move $a1, $gp
	
Top:	
	sw $s6, ($a1)
	add $a1, $a1, 4
	blt $a1, $a2, Top
	lh $a1, width	
	lh $a2, height
	multu $a1, $a2		
	mflo $a2		
	sub $a2, $a2, $a1	
	sll $a2, $a2, 2		
	add $a2, $a2, $gp		
	subi $a1, $a1, 1	
	sll $a3, $a1, 2		
	move $a1, $gp		
Sides:	
	sw $s6, ($a1)
	add $a1, $a1, $a3
	sw $s6, ($a1)
	add $a1, $a1, 4
	blt $a1, $a2, Sides
	move $a3, $a1
	lh $a1, width
	lh $a2, height
	multu $a1, $a2
	mflo $a2
	sll $a2, $a2, 2	
	add $a2, $a2, $gp
	move $a1, $a3
Bottom:
	sw $s6, ($a1)
	add $a1, $a1, 4
	blt $a1, $a2, Bottom
	jr $ra

Banner:
	or $a1, $gp, $zero	# reset gp
	lw $a0, green		# font green
	addi $a1, $a1, 264	# banner: WORD, letter W 
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $a1, $gp, $zero
	addi $a1, $a1, 296	# letter O
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $a1, $gp, $zero
	addi $a1, $a1, 328	# letter R
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $a1, $gp, $zero
	addi $a1, $a1, 356	# letter D
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $a1, $gp, $zero	# reset gp
	lw $a0, red		# font red
	addi $a1, $a1, 1164	# banner: jumblr, letter j
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 124
	sw $a0, ($a1)
	addi $a1, $a1, 128
	sw $a0, ($a1)
	addi $a1, $a1, 128
	sw $a0, ($a1)
	addi $a1, $a1, 120
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 124
	sw $a0, ($a1)
	or $a1, $gp, $zero	# reset gp
	addi $a1, $a1, 1180	# banner: jumblr, letter u
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 120
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $a1, $gp, $zero	# reset gp
	addi $a1, $a1, 1204	# banner: jumblr, letter m
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 116
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	or $a1, $gp, $zero	# reset gp
	addi $a1, $a1, 1224	# banner: jumblr, letter b
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 120
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 120
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $a1, $gp, $zero	# reset gp
	addi $a1, $a1, 1244	# banner: jumblr, letter l
	sw $a0, ($a1)
	addi $a1, $a1, 128
	sw $a0, ($a1)
	addi $a1, $a1, 128
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $a1, $gp, $zero	# reset gp
	addi $a1, $a1, 1256	# banner: jumblr, letter r
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 120
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 120
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	jr $ra

gui_letters:
	or $t1, $ra, $zero	# preserve $ra
	or $a1, $gp, $zero	# reset gp
	li $a0, 0x0		# font black
	addi $a1, $a1, 2056	# position letter1
	la $t9, word_buffer
	lbu $t8, 0($t9)
	beq $t8, 0x61, LetterA
	beq $t8, 0x62, LetterB
	beq $t8, 0x63, LetterC
	beq $t8, 0x64, LetterD
	beq $t8, 0x65, LetterE
	beq $t8, 0x66, LetterF
	beq $t8, 0x67, LetterG
	beq $t8, 0x68, LetterH
	beq $t8, 0x69, LetterI
	beq $t8, 0x6A, LetterJ
	beq $t8, 0x6B, LetterK
	beq $t8, 0x6C, LetterL
	beq $t8, 0x6D, LetterM
	beq $t8, 0x6E, LetterN
	beq $t8, 0x6F, LetterO
	beq $t8, 0x70, LetterP
	beq $t8, 0x71, LetterQ
	beq $t8, 0x72, LetterR
	beq $t8, 0x73, LetterS
	beq $t8, 0x74, LetterT
	beq $t8, 0x75, LetterU
	beq $t8, 0x76, LetterV
	beq $t8, 0x77, LetterW
	beq $t8, 0x78, LetterX
	beq $t8, 0x79, LetterY
	beq $t8, 0x7A, LetterZ
	#jal LetterA
	#lbu $t8, 0($t9)
	#addi $a1, $a1, 2088	# position letter2
	#jal LetterA
	#lbu $t8, 0($t9)
	#addi $a1, $a1, 2120	# position letter2
	#lbu $t8, 0($t9)
	#addi $a1, $a1, 2148	# position letter2
	#lbu $t8, 0($t9)
	#addi $a1, $a1, 2832	# position letter2
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterA:
	#bne $t8, 0x61, LetterB
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4 	
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	jr $ra
	
LetterB:
	#bne $t8, 0x62, LetterC
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4	# row 5
	sw $a0, ($a1)
	or $ra, $t1, $zero 	# return $ra
	jr $ra
	
LetterC:
	#bne $t8, 0x63, LetterD
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4	
	sw $a0, ($a1)
	addi $a1, $a1, 4	
	sw $a0, ($a1)
	addi $a1, $a1, 4	
	sw $a0, ($a1)
	addi $a1, $a1, 4	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2	
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3	
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 4	
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 5	
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra

LetterD:
	#bne $t8, 0x64, LetterE
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra

LetterE:
	#bne $t8, 0x65, LetterF
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterF:
	#bne $t8, 0x66, LetterG
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 5
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra

LetterG:
	#bne $t8, 0x67, LetterH
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterH:
	#bne $t8, 0x68, LetterI
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)	
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterI:
	#bne $t8, 0x69, LetterJ
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 120	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 120	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterJ:
	#bne $t8, 0x6A, LetterK
	or $t1, $ra, $zero	# preserve $ra
	addi $a1, $a1, 8	# row 1
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterK:
	#bne $t8, 0x6B, LetterL
	or $t1, $ra, $zero	# preserve $ra
	addi $a1, $a1, 8	# row 1
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 120	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterL:
	#bne $t8, 0x6C, LetterM
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 128	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterM:
	#bne $t8, 0x6D, LetterN
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterN:
	#bne $t8, 0x6E, LetterO
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterO:
	#bne $t8, 0x6F, LetterP
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterP:
	#bne $t8, 0x70, LetterQ
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 5
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterQ:
	#bne $t8, 0x71, LetterR
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 8	
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 12	
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterR:
	#bne $t8, 0x72, LetterS
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 12
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterS:
	#bne $t8, 0x73, LetterT
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterT:
	#bne $t8, 0x74, LetterU
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 120	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 5
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterU:
	#bne $t8, 0x75, LetterV
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra

LetterV:
	#bne $t8, 0x76, LetterW
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 124	# row 5
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterW:
	#bne $t8, 0x77, LetterX
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterX:
	#bne $t8, 0x78, LetterY
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 124	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 124	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 8
	sw $a0, ($a1)
	addi $a1, $a1, 116	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 16
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterY:
	#bne $t8, 0x79, LetterZ
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 16
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 16	
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)	
	addi $a1, $a1, 128	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra
	
LetterZ:
	or $t1, $ra, $zero	# preserve $ra
	sw $a0, ($a1)		# row 1
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 2
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 3
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 112	# row 4
	sw $a0, ($a1)
	addi $a1, $a1, 128	# row 5
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	addi $a1, $a1, 4
	sw $a0, ($a1)
	or $ra, $t1, $zero	# return $ra
	jr $ra