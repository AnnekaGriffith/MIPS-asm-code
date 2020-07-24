.text
.globl main
main: 
	li $t0, 10 	#number of iterations
	li $t1, 0 	#t1 is counter
	li $t2, 17 	#t2 holds value to modify
loop:
	beq $t1, $t0, end #if t1 == t0 end loop
	add $t2, $t2, $t1 
	addi $t1, $t1, 1
	j loop 
end:
	li $v0,10
	syscall