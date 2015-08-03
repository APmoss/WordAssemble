	# data.asm
	# Global resource for static data.
	
	.globl	data_prompt
	.globl	data_invalid
	.globl	data_press_any_key
	.globl	data_words_path
	.globl	data_testFile_path
	.globl	data_press_to_continue
	
	.data
data_prompt:
	.asciiz	"Hello"
data_invalid:
	.asciiz	"Sorry, that is not a valid input. Please try again."
data_press_any_key:
	.asciiz	"Press any key to return to the main menu."
data_words_path:
	.asciiz	"content/words.txt"
data_testFile_path:
	.asciiz	"content/testFile.txt"
data_press_to_continue:
	.asciiz	"Press any key to continue."
