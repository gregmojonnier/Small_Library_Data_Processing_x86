// @author Greg Mojonnier
.data

.bss

.text
.globl items
.globl find_item
find_item:
	enter $0, $0

// Prepare to loop through list of items
// %ecx will be our pointer to the Item we check each iteration
	movl items, %ecx 
.L1_START:
	cmp $0x0, %ecx
	je NO_MATCHING_ITEM_FOUND

// Get current item's lefthand CID
// It starts at byte 16(is 2 bytes in size)
	movw 16(%ecx), %dx

	// Compare to the lefthand CID parameter passed in(arg 1)
	cmpw %dx, 8(%ebp)
	jne .L1_NEXT_ITERATION

// Get current item's righthand CID
// It starts at byte 18(is 2 bytes in size)
	movw 18(%ecx), %dx

	// Compare to the righthand CID parameter passed in(arg 2)
	cmpw %dx, 12(%ebp)
	je FOUND_MATCHING_ITEM

.L1_NEXT_ITERATION:
	// The pointer to the next item entry in the list is at byte 0
	movl (%ecx), %ecx
	jmp .L1_START

EPILOGUE:
	leave
	ret	

FOUND_MATCHING_ITEM:
	movl %ecx, %eax
	jmp EPILOGUE

NO_MATCHING_ITEM_FOUND:
	movl $0x0, %eax
	jmp EPILOGUE
