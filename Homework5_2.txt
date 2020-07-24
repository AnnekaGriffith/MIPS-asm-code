.data

	matrixR:	.space 96 #space for 3x4 array
	matrix1: 	.float 0.50, 0.25, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.15, 16.16
	matrix2: 	.float 16.16, 15.15, 14.0, 13.0, 12.0, 11.0, 10.0001, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0
	size1:		.word 0, 0
	size2:		.word 0, 0
	endl: 		.asciiz "\n"
	tab: 		.asciiz "\t"
	prompt: 	.asciiz "Matrix:"
	prompt_p: 	.asciiz "Enter q value: "
	prompt_q: 	.asciiz "Enter p value: "
	prompt_r: 	.asciiz "Enter r value: "
	
.text
.globl main

main:

    addi	$sp, $sp, -16
    sw 		$ra, 0($sp)
	sw 		$s0, 4($sp)            
	sw 		$s1, 8($sp)
	sw 		$s2, 12($sp)
	
	la 		$a0, prompt_p
	li 		$v0, 4
	syscall
	li		$v0, 5
	syscall
	move	$t7, $v0
	
	la 		$a0, prompt_q
	li 		$v0, 4
	syscall
	li		$v0, 5
	syscall
	move	$t6, $v0
	
	la 		$a0, prompt_r
	li 		$v0, 4
	syscall
	li		$v0, 5
	syscall
	move	$t5, $v0
	
	la		$s7, size1
	lw		$t7, 4($s7)
	lw		$t6, 0($s7)
	
	la		$s6, size2
	lw		$t6, 4($s6)
	lw		$t5, 0($s6)
	
	la 		$a0, matrix1
	jal 	print_matrix
	
	jal 	print_new_line

	la 		$a0, matrix2
	jal 	print_matrix

	la 		$a0, matrix1
	la 		$a1, matrix2
	la 		$a2, matrixR
	jal 	matrix_mult

	jal 	print_new_line

	la 		$a0, matrixR
	jal 	print_matrix
	li 		$v0, 10
	syscall

	lw 		$s2, 12($sp)
	lw 		$s1, 8($sp)
	lw 		$s0, 4($sp)
	lw 		$ra, 0($sp)
	addi 	$sp, $sp, 16 
	jr 		$ra

matrix_mult:
	
	addi 	$sp, $sp, -32
	sw 		$ra, 0($sp)
	sw 		$s0, 4($sp)
	sw 		$s1, 8($sp)
	sw 		$s2, 12($sp)
	sw 		$s3, 16($sp)
	sw 		$s4, 20($sp)
	sw 		$s5, 24($sp)
	sw 		$s6, 28($sp)

   

	# f4 = product(f0, f1)
	# f6 = matrixR[i][j]
	or 		$s0, $s0, $a0
	or 		$s1, $s1, $a1
	or 		$s2, $s2, $a2
	ori 	$s3, $s3, 0              # s0 = i = 0
	ori 	$s4, $s4, 0              # s1 = j = 0
	ori 	$s5, $s5, 0              # s2 = k = 0
	ori 	$s6, $s6, 4              # s3 = n = 3
           
matrix_mult_loop1:
    li 		$s4, 0

matrix_mult_loop2:

	li 		$s5, 0
	li.s 	$f6, 0.0           

matrix_mult_loop3:

	#assign f0 to matrix1[i][k]
	# t0 = i * n
	# t1 = t0 + i

	mult 	$s3, $s6
	mflo 	$t0
	add 	$t1, $t0, $s5
	sll 	$t1, $t1, 3
	add 	$t2, $t1,$s0
	l.s 	$f0, 0($t2) 				# f0 = matrix1[i][k]

	#assign f2 to firstMatrix[k][i]
	# t0 = k * n
	# t1 = t0 + j
	
	mult 	$s5, $s6
	mflo 	$t0
	add 	$t1, $t0, $s4
	sll 	$t1, $t1, 3
	add 	$t2, $t1, $s1	
	l.s 	$f2, 0($t2)  				# f2 = matrix2[k][j]

	mul.s 	$f4, $f0, $f2
	add.s 	$f6, $f6, $f4

	addi 	$s5, $s5, 1 # s2 = ++k
	bne 	$s5, $s6, matrix_mult_loop3 # if(k != 4)

	# if(k == 4)
	# t0 = i * n
	# t1 = t0 + j

	mult 	$s3, $s6  # store z[i][j]
	mflo 	$t0
	add 	$t1, $t0, $s4       		#i*n+j
	sll 	$t1, $t1, 3                	#8*(i*n+j)
	add 	$t2, $t1, $s2       		#&z[i][j]
	s.s 	$f6, 0($t2)            

	addi 	$s4, $s4, 1 # s1 = ++j
	bne 	$s4, $s6, matrix_mult_loop2 # if(j != 4)

	# if(j == 4)
	
	addi 	$s3, $s3, 1 # s0 = ++i
	bne 	$s3, $s6, matrix_mult_loop1 # if(i != 4)

	# if(i == 4)      
	#End of matrixMult method
   
	lw 		$s6, 28($sp)
	lw 		$s5, 24($sp)
	lw 		$s4, 20($sp)
	lw 		$s3, 16($sp)
	lw 		$s2, 12($sp)
	lw 		$s1, 8($sp)
	lw 		$s0, 4($sp)
	lw 		$ra, 0($sp)
	addi 	$sp, $sp, 32
	jr 		$ra
    

print_matrix:
	addi 	$sp, $sp, -12
	sw 		$ra, 0($sp)
	sw 		$s0, 4($sp) 				# s0 = current array
	sw 		$s1, 8($sp) 				# s1 = i
	sw 		$s2, 12($sp) 				# s2 = n

	# a0 = current array
	
	or 		$s0, $a0, $zero

	# print array prompt

	la 		$a0, prompt
	li 		$v0, 4
	syscall
   
	# print new line
	
	jal 	print_new_line
	li 		$s1, 0            			# s1 = i = 0
	li 		$s2, 15          			# s2 = n = 15

print_matrix_loop:
	sll 	$t0, $s1, 3
	add 	$t1, $t0, $s0

	# print out current item
	li 		$v0, 3
	syscall

	# print out a space
	jal 	print_space

	# if(i % 4 == 0)
	li 		$t0, 4
	addi 	$s1, $s1, 1
	div 	$s1, $t0
	mfhi 	$t0
	bne 	$t0, $zero, skip_new_line

	jal 	print_new_line      

skip_new_line: # else if(i % 4 != 0)       
	bne 	$s1, $s2, print_matrix_loop # if(i != n)

	lw 		$s2, 12($sp)
	lw 		$s1, 8($sp)
	lw 		$s0, 4($sp)
	lw 		$ra, 0($sp)
	addi 	$sp, $sp, 12
	jr 		$ra        

print_new_line:
	addi 	$sp, $sp, -4
	sw 		$ra, 0($sp)

	la 		$a0, endl
	li 		$v0, 4
	syscall
   
	lw 		$ra, 0($sp)
	addi 	$sp, $sp, 4
	jr 		$ra   

print_space:
	addi 	$sp, $sp, -4
	sw 		$ra, 0($sp)

	la 		$a0, tab
	li 		$v0, 4
	syscall

	lw 		$ra, 0($sp)
	addi 	$sp, $sp, 4
	jr 		$ra