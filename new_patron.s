// @author Greg Mojonnier
.data

.bss

.text
.globl new_patron
new_patron:
	enter $0, $0
// char pid1, uint16_t pid2, char* name

// Allocate 16 bytes(size of Patron size)
	movl $16, %eax
	pushl %eax
	call allocate
	add $4, %esp

// Return Null if any allocations fail
	cmp $0x0, %eax
	je ALLOCATION_FAILED	

// Move our allocated bytes into %ecx
	movl %eax, %ecx
	
// Zero out the following, Next pointer(byte 0)
// first item checked out pointer(byte 4)
// Count of items checked out(byte 15)
	movl $0x0, (%ecx)
	movl $0x0, 4(%ecx)
	movb $0x0, 15(%ecx)

// Move first arg, char portion pid into(byte 14)
	movb 8(%ebp), %dl
	movb %dl, 14(%ecx)
	
// Move second arg, numeric portion pid into(byte 12)
	movw 12(%ebp), %dx
	movw %dx, 12(%ecx)

// Store 3rd arg(char * name)
	//movl 16(%ebp), %edx

// Save our saved patron struct location(16 bytes) on stack
// and then find length of char* name
	//pushl %ecx
	//pushl %edx
	//call strlen
	//add $4, %esp

// Allocate space for char* name
	//add $1, %eax
	//pushl %eax
	//call allocate
	//add $4, %esp

// Restore location to our patron struct
	//pop %ecx

	//cmp $0x0, %eax
	//je ALLOCATION_FAILED

// Move our pointer to allocated space for char* name
// into byte 8 of the patron struct we allocated earlier
	//movl %eax, 8(%ecx)

	
// Save our patron struct pointer for later use
	//pushl %ecx

	//movl 16(%ebp), %edx
	//pushl 16(%ebp)
	//pushl %edx
	//pushl 8(%ecx)
	//call strcpy

	//add $8, %esp

	//pop %ecx

	movl 16(%ebp), %edx
	movl %edx, 8(%ecx)

// Return pointer to allocated patron struct
	movl %ecx, %eax

EPILOGUE:
	leave
	ret	

ALLOCATION_FAILED:
	movl $0x0, %eax
	jmp EPILOGUE
