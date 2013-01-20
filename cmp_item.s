// @author Greg Mojonnier
.data

.bss

.text
/*
* int cmp_item( Item* i1, Item* i2 )
*
* Compares the two Items. If item1 has higher precedence
* than -1 is returned. If both are equal than 0 is returned.
* If item1 has lower precedence than 1 is returned.
*
*/
.globl cmp_item
cmp_item:
	enter $0, $0

// Verify 2 arguments(Item pointers) aren't NULL
// return 0 if either is NULL
	// 2nd argument
	movl 12(%ebp), %eax
	cmp $0x0, %eax
	je ITEMS_ARE_EQUAL

	// 1st argument
	movl 8(%ebp), %eax
	cmp $0x0, %eax
	je ITEMS_ARE_EQUAL

// Start by comparing item's authors
// Push item argument's authors on to stack for strcmp in reverse order
// Author c-string starts at byte 8 within Item struct

	// 2nd argument
	movl 12(%ebp), %eax
	pushl 8(%eax)

	// 1st argument
	movl 8(%ebp), %edx
	pushl 8(%edx)

	call strcmp
	add $8, %esp

	cmp $0, %eax
	je EQUAL_AUTHORS
	jle ITEM1_HIGHER_PRECEDENCE
	jge ITEM1_LOWER_PRECEDENCE
EPILOGUE:
	leave
	ret	

EQUAL_AUTHORS:

// Since item's authors are equal compare by their title
// Push item argument's titles on to stack for strcmp in reverse order
// Title c-string starts at byte 12 within Item struct

	// 2nd argument
	movl 12(%ebp), %eax
	pushl 12(%eax)

	// 1st argument 
	movl 8(%ebp), %eax
	pushl 12(%eax)

	call strcmp
	add $8, %esp

	cmp $0, %eax
	je EQUAL_TITLES
	jle ITEM1_HIGHER_PRECEDENCE
	jge ITEM1_LOWER_PRECEDENCE

EQUAL_TITLES:

// Since item's titles are equal compare by their CID
// Lefthand CID starts at byte 16, righthand CID at byte 18(Their 2 bytes in size) 

	// put item1's lefthand CID in %dx
	movl 8(%ebp), %edx
	movw 16(%edx), %dx

	// put item2's lefthand CID in %ax
	movl 12(%ebp), %eax
	movw 16(%eax), %ax
	cmp %ax, %dx

	jl ITEM1_HIGHER_PRECEDENCE
	jg ITEM1_LOWER_PRECEDENCE

// both item's lefthand CID's are equal so check righthand CID's	

	// put item1's righthand CID in %dx
	movl 8(%ebp), %edx
	movw 18(%edx), %dx

	// put item2's righthand CID in %ax
	movl 12(%ebp), %eax
	movw 18(%eax), %ax

	cmp %ax, %dx

	jg ITEM1_LOWER_PRECEDENCE
	jl ITEM1_HIGHER_PRECEDENCE
	jmp ITEMS_ARE_EQUAL 

ITEM1_HIGHER_PRECEDENCE:
	movl $-1, %eax
	jmp EPILOGUE

ITEM1_LOWER_PRECEDENCE:
	movl $1, %eax
	jmp EPILOGUE

ITEMS_ARE_EQUAL:
	movl $0, %eax
	jmp EPILOGUE 
