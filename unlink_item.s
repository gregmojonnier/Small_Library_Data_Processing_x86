// @author Greg Mojonnier
.data

.bss

.text
.globl items

/*
* Item* unlink_item( uint16_t cid1, uint16_t cid_2 )
*
* Traverses the Item list and removes the item with the
* specified CID. If this Item is found and removed from the list,
* returns a pointer to the node that was removed; otherwise,
* returns a null pointer.
*
*/
.globl unlink_item
unlink_item:
	enter $0, $0

// Check if head item in list is item node to unlink
	sub $8, %esp
	movl items, %eax
	
	// Move head item at 0(%esp) and nothing at 4(%esp)
	// the nothing at 4(%esp) is just a place holder in this
	// call of does_cid_match_item but will be utilized in the loop below
	movl %eax, (%esp)
	call does_cid_match_item
	
	cmp $0x0, %eax

	je .L1_FIRST_START
	jg HEAD_ITEM_IS_MATCH

	add $8, %esp

// Head list item is null, return null/exit
	movl $0x0, %eax
	jmp EPILOGUE

HEAD_ITEM_IS_MATCH:
	pop %eax
	add $4, %esp

// were unlinking head of list
	movl (%eax), %edx
	movl %edx, items

	jmp EPILOGUE

// Prepare to loop through list of items
// %eax will be our pointer to the Item we check each iteration
.L1_FIRST_START:
	pop %eax
	add $4, %esp
.L1_START:

	sub $8, %esp
// store predecessor at 4(%esp) and current at 0(%esp)
	movl %eax, 4(%esp) 
	movl (%eax), %eax
	movl %eax, (%esp)
	call does_cid_match_item

	cmp $0, %eax
	pop %eax
	pop %ecx
	// %ecx is storing %eax's predecessor

	je .L1_START
	jg ITEM_IS_MATCH

	// next item was null return null
	movl $0x0, %eax
	jmp EPILOGUE

ITEM_IS_MATCH:	

	// Link up %eax's predecessor's next (%ecx)
	// with %eax's next (%eax)
	movl (%eax), %edx
	movl %edx, (%ecx)

EPILOGUE:
	leave
	ret	

/*
* int does_cid_match_item( Item* i )
*
* Takes an Item* argument at 8(%ebp) and determines
* if the cid matches the item.
* The CID is already on the stack at lefthand cid 24(%ebp)
* and righthand cid 28(%ebp). Item i's next is also on the stack
* already at 12(%ebp) used in the item loop above.
* It is mandatory that this function is only called after/ within
* the unlink_item function above since it makes assumptions as to what
* is already on the stack.
*
*
*/
does_cid_match_item:
	enter $0, $0

	movl $0x0, %eax
	movl 8(%ebp), %ecx

	cmp $0x0, %ecx
	jne ITEM_NOT_NULL_CONTINUE
	
	movl $-1, %eax
	jmp EPILOGUE1

ITEM_NOT_NULL_CONTINUE:
	movw 24(%ebp), %dx
	cmpw %dx, 16(%ecx)
	jne EPILOGUE1

	movw 28(%ebp), %dx
	cmpw %dx, 18(%ecx)
	jne EPILOGUE1
	
	movl $1, %eax

EPILOGUE1:
	leave
	ret	
