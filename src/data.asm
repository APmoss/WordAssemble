	# data.asm
	# Global resource for static data.
	
	.globl	data_prompt
	.globl	data_words_path
	
	.data
data_prompt:
	.asciiz	"Hello\n"
data_words_path:
	.asciiz	"content/words.txt"
