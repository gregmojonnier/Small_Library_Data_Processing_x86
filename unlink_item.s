// @author Greg Mojonnier
.data

.bss

.text
.globl items
.globl find_item
.globl unlink_item
unlink_item:
	enter $0, $0



	sub $8, %esp
	movl items, %eax
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
// %ecx will be our pointer to the Item we check each iteration
// %eax has current thing
.L1_FIRST_START:
	pop %eax
	add $4, %esp
.L1_START:

	sub $8, %esp
// store current
	movl %eax, 4(%esp) 
	movl (%eax), %eax
	movl %eax, (%esp)
 // store current's next
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

	// %ecx is storing %eax's predecessor

	// %eax = current, %ecx = predecessor

	// move %eax's next into %edx
	movl (%eax), %edx
	movl %edx, (%ecx)

EPILOGUE:
	leave
	ret	

does_cid_match_item:
// takes item* @ 8(%ebp), this items next is also at 12(%ebp) but thats just saved for the loop
// The lefthand cid @ 24(%ebp), righthand cid @ 28(%ebp)
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
