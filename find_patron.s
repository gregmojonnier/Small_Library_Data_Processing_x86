
// @author Greg Mojonnier
.data

.bss

.text
.globl patrons
.globl find_patron
find_patron:
	enter $0, $0

// Prepare to loop through list of patrons
// %ecx will be our pointer to the Patron we check each iteration
	movl patrons, %ecx 
.L1_START:
	cmp $0x0, %ecx
	je NO_MATCHING_PATRON_FOUND

// Get current patron's character portion of CID
// It starts at byte 14(is 1 bytes in size)
	movb 14(%ecx), %dl

	// Compare to the character portion of CID parameter passed in(arg 1)
	cmpb %dl, 8(%ebp)
	jne .L1_NEXT_ITERATION

// Get current patron's numeric portion of CID
// It starts at byte 12(is 2 bytes in size)
	movw 12(%ecx), %dx

	// Compare to the numeric portion of CID parameter passed in(arg 2)
	cmpw %dx, 12(%ebp)
	je FOUND_MATCHING_PATRON

.L1_NEXT_ITERATION:
	// The pointer to the next patron entry in the list is at byte 0
	movl (%ecx), %ecx
	jmp .L1_START

EPILOGUE:
	leave
	ret	

FOUND_MATCHING_PATRON:
	movl %ecx, %eax
	jmp EPILOGUE

NO_MATCHING_PATRON_FOUND:
	movl $0x0, %eax
	jmp EPILOGUE
