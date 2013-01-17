// uint16_t cid1, cid2
// @author Greg Mojonnier
.data
	printaddr:
		.asciz "The global item head pointer is %p\n\n"
	printauth:
		.asciz "The head item's author is %s\n\n"

.bss

.text
.globl items
.globl find_item
find_item:
	enter $0, $0

	movl items, %eax
	pushl %eax
	pushl $printaddr
	call printf
	add $8, %esp

	movl items, %eax
	pushl 8(%eax)
	pushl $printauth
	call printf
	add $8, %esp

EPILOGUE:
	leave
	ret	
