
// @author Greg Mojonnier
.data

.bss

.text
.globl cmp_patron
cmp_patron:
	enter $0, $0

// Verify 2 arguments(Patron pointers) aren't NULL
// return 0 if either is NULL
	// 2nd argument
	movl 12(%ebp), %eax
	cmp $0x0, %eax
	je PATRONS_ARE_EQUAL

	// 1st argument
	movl 8(%ebp), %eax
	cmp $0x0, %eax
	je PATRONS_ARE_EQUAL

// Start by comparing patron's names
// Push patron argument's names on to stack for strcmp in reverse order
// Name c-string starts at byte 8 within Patron struct

	// 2nd argument
	movl 12(%ebp), %eax
	pushl 8(%eax)

	// 1st argument
	movl 8(%ebp), %edx
	pushl 8(%edx)

	call strcmp
	add $8, %esp

	cmp $0, %eax
	je EQUAL_NAMES
	jle PATRON1_HIGHER_PRECEDENCE
	jge PATRON1_LOWER_PRECEDENCE
EPILOGUE:
	leave
	ret	

EQUAL_NAMES:
// Since patron's names are equal compare by their PID
// Character portion PID starts at byte 14(1 byte in size), numeric portion PID at byte 12(2 bytes in size) 

	// put patron1's character portion PID in %dl
	movl 8(%ebp), %edx
	movb 14(%edx), %dl

	// put patron2's numeric portion PID in %al
	movl 12(%ebp), %eax
	movb 14(%eax), %al

	cmp %al, %dl

	jl PATRON1_HIGHER_PRECEDENCE
	jg PATRON1_LOWER_PRECEDENCE

// both patron's character portion PID's are equal so check numeric portion PID

	// put patron1's numeric CID in %dx
	movl 8(%ebp), %edx
	movw 12(%edx), %dx

	// put patron2's numeric CID in %ax
	movl 12(%ebp), %eax
	movw 12(%eax), %ax

	cmp %ax, %dx

	jg PATRON1_LOWER_PRECEDENCE
	jl PATRON1_HIGHER_PRECEDENCE
	jmp PATRONS_ARE_EQUAL 

PATRON1_HIGHER_PRECEDENCE:
	movl $-1, %eax
	jmp EPILOGUE

PATRON1_LOWER_PRECEDENCE:
	movl $1, %eax
	jmp EPILOGUE

PATRONS_ARE_EQUAL:
	movl $0, %eax
	jmp EPILOGUE 
