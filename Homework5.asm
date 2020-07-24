.data 

	num1: .float 12.56
	num2: .float 3.4
	
.text
.globl main

main:

	l.s $f4, num1	
	l.s $f5, num2
	
	add.s $f6, $f4, $f5 
	div.s $f8, $f4, $f5
	
	li $v0, 10
	syscall
