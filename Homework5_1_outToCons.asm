.data 

	num1: 	.float 12.56
	num2: 	.float 3.4
	tab:	.asciiz "\t"
.text
.globl main

main:

	l.s $f4, num1	
	l.s $f5, num2
	
	add.s 	$f6, $f4, $f5
	mov.s 	$f12, $f6 
	li 		$v0, 2
	syscall
	
	la $a0, tab
    li $v0, 4
    syscall
	
	div.s $f8, $f4, $f5
	mov.s $f12, $f8 
	li $v0, 2
	syscall
	
	li $v0, 10
	syscall
