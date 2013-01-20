// @author Greg Mojonnier
.data

.bss

.text
.globl new_item
new_item:
	enter $0, $0
// uint16_t cid1, uint16_t cid2, char* author, char* title, uint8_t copies

// Allocate 24 bytes(size of Item struct)
	movl $24, %eax
	pushl %eax
	call allocate
	add $4, %esp

// Return Null if any allocations fail
	cmp $0x0, %eax
	je ALLOCATION_FAILED	

// Zero out the following, Next pointer(byte 0)
// first patron checked out item pointer(byte 4)
	movl $0x0, (%eax)
	movl $0x0, 4(%eax)

// Move first arg, lefthand cid into(byte 16)
	movw 8(%ebp), %dx
	movw %dx, 16(%eax)

// Move second arg, righthand cid into(byte 18)
	movw 12(%ebp), %dx
	movw %dx, 18(%eax)

// Move third arg, char* author  into(byte 8)
	movl 16(%ebp), %edx
	movl %edx, 8(%eax)

// Move fourth arg, char* title  into(byte 12)
	movl 20(%ebp), %edx
	movl %edx, 12(%eax)

// Move fifth arg, uint8_t num copies  into(byte 20)
	movb 24(%ebp), %dl
	movb %dl, 20(%eax)

// Count of item available for check out(byte 21)
	movb %dl, 21(%eax)
EPILOGUE:
	leave
	ret	

ALLOCATION_FAILED:
	movl $0x0, %eax
	jmp EPILOGUE
