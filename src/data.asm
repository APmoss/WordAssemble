	# data.asm
	# Global resource for static data.
	
	.globl	data_prompt
	.globl	data_welcome
	.globl	data_invalid
	.globl	data_goodbye
	.globl	data_words_path
	.globl	data_testFile_path
	
	.data
data_prompt:
	.asciiz	"Hello"
data_welcome:
	.asciiz	"Welcome to WordAssemble! Select an option to begin-\n1) New Game\n2) High Scores\n3) Exit\n"
data_invalid:
	.asciiz	"Sorry, that is not a valid input. Please try again."
data_goodbye:
	.asciiz	"Thanks for playing WordAssemble. Goodbye!"
data_words_path:
	.asciiz	"content/words.txt"
data_testFile_path:
	.asciiz	"content/testFile.txt"
