// @author Greg Mojonnier
.data

.bss

.text
/*
* Patron* new_patron( char pid1, uint16_t pid2, char* name )
*
* Allocates a new Patron node. If the allocation succeeds, copies
* the supplied arguments into the appropriate fields of the new node,
* clears all other fields to 0, and returns the pointer to the new node.
* If the allocation fails, returns a null pointer.
*
*/
.globl new_patron
new_patron:
	enter $0, $0
// char pid1, uint16_t pid2, char* name

// Allocate 16 bytes(size of Patron struct)
	movl $16, %eax
	pushl %eax
	call allocate
	add $4, %esp

// Return Null if any allocations fail
	cmp $0x0, %eax
	je ALLOCATION_FAILED	

// Zero out the following, Next pointer(byte 0)
// first item checked out pointer(byte 4)
// Count of items checked out(byte 15)
	movl $0x0, (%eax)
	movl $0x0, 4(%eax)
	movb $0x0, 15(%eax)

// Move first arg, char portion pid into(byte 14)
	movb 8(%ebp), %dl
	movb %dl, 14(%eax)
	
// Move second arg, numeric portion pid into(byte 12)
	movw 12(%ebp), %dx
	movw %dx, 12(%eax)

// Make byte 8 of our patron struct point to same char
// as supplied 3rd arg char* name
	movl 16(%ebp), %edx
	movl %edx, 8(%eax)

EPILOGUE:
	leave
	ret	

ALLOCATION_FAILED:
	movl $0x0, %eax
	jmp EPILOGUE
