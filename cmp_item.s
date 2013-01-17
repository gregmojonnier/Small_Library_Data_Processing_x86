// @author Greg Mojonnier
.data
	theauthors:
		.asciz "item1 author: %s\n ---- item2 author: %s\n\n"
	thetitles:
		.asciz "item1 title: %s\n ---- item2 title: %s\n\n"
	theleftcid:
		.asciz "item1 leftcid: %hu\n ---- item2 leftcid: %hu\n\n"
	therightcid:
		.asciz "item1 rightcid: %hu\n ---- item2 rightcid: %hu\n\n"
	madeit:
		.asciz "Made it to the equal titles!\n"

.bss

.text
	.globl cmp_item
	cmp_item:
		pushl %ebp
		movl %esp, %ebp

		movl 12(%ebp), %eax
		cmp $0x0, %eax
		je ITEMS_ARE_EQUAL

		movl 8(%ebp), %eax
		cmp $0x0, %eax
		je ITEMS_ARE_EQUAL

// Push item argument's authors on to stack
// for strcmp in reverse order
		// 2nd argument item pointer
		// push author
		movl 12(%ebp), %eax
		pushl 8(%eax)

		// 1st argument item pointer
		// push author
		movl 8(%ebp), %edx
		pushl 8(%edx)

		pushl $theauthors
		call printf;
		add $12, %esp

		// 2nd argument item pointer
		// push author
		movl 12(%ebp), %eax
		pushl 8(%eax)

		// 1st argument item pointer
		// push author
		movl 8(%ebp), %edx
		pushl 8(%edx)

		call strcmp
		add $8, %esp
	
		cmp $0, %eax
		je EQUAL_AUTHORS
		jle ITEM1_HIGHER_PRECEDENCE
		jge ITEM1_LOWER_PRECEDENCE


//		pushl %eax
//		pushl $theresult
//		call printf
//		add $8, %esp

	EPILOGUE:
		movl %ebp, %esp
		pop %ebp
		ret	

// implement yo
	EQUAL_AUTHORS:

// Push item argument's titles on to stack
// for strcmp in reverse order
		// 2nd argument item pointer
		// push title
		movl 12(%ebp), %eax
		pushl 12(%eax)

		// 1st argument item pointer
		// push title
		movl 8(%ebp), %eax
		pushl 12(%eax)
		
		pushl $thetitles
		call printf
		add $12, %esp

		// 2nd argument item pointer
		// push title
		movl 12(%ebp), %eax
		pushl 12(%eax)

		// 1st argument item pointer
		// push title
		movl 8(%ebp), %eax
		pushl 12(%eax)

		call strcmp
		add $8, %esp

		cmp $0, %eax
		je EQUAL_TITLES
		jle ITEM1_HIGHER_PRECEDENCE
		jge ITEM1_LOWER_PRECEDENCE

	ITEM1_HIGHER_PRECEDENCE:
		movl $-1, %eax
		jmp EPILOGUE

	ITEM1_LOWER_PRECEDENCE:
		movl $1, %eax
		jmp EPILOGUE

	ITEMS_ARE_EQUAL:
		movl $0, %eax
		jmp EPILOGUE 

	EQUAL_TITLES:

		xor %eax, %eax
		xor %ecx, %ecx
		xor %edx, %edx

// Compare item1's lefthand CID with item2's

		// put item2's lefthand CID in %ax
		movl 12(%ebp), %ecx
		movw 16(%ecx), %ax
		pushl %eax

		xor %ecx, %ecx 

		// put item1's lefthand CID in %dx
		movl 8(%ebp), %ecx
		movw 16(%ecx), %dx
		pushl %edx


		//pushl %ax
		//pushw %dx
		pushl $theleftcid
		call printf
		add $12, %esp


// Compare item1's lefthand CID with item2's
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
		xor %edx, %edx
		xor %eax, %eax
		xor %ecx, %ecx

		// put item1's righthand CID in %dx
		movl 8(%ebp), %ecx
		movw 18(%ecx), %dx

		xor %ecx, %ecx

		// put item2's righthand CID in %ax
		movl 12(%ebp), %ecx
		movw 18(%ecx), %ax

		pushl %eax
		pushl %edx

		pushl $therightcid
		call printf
		add $12, %esp

		// put item1's righthand CID in %dx
		movl 8(%ebp), %ecx
		movw 18(%ecx), %dx

		xor %ecx, %ecx

		// put item2's righthand CID in %ax
		movl 12(%ebp), %ecx
		movw 18(%ecx), %ax

		cmp %ax, %dx

		jg ITEM1_LOWER_PRECEDENCE
		jl ITEM1_HIGHER_PRECEDENCE
		jmp ITEMS_ARE_EQUAL 
