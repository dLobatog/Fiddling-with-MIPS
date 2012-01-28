.data
ask_string:	.asciiz	"Give me the quantity of numbers: "
wrong_input:	.asciiz "Quantity of numbers must be greater than 0 and less than 51"
ask_number:	.asciiz "Give me a number: "
maximum:	.asciiz "Maximum number is: "
minimum:	.asciiz "Minimum number is: "
space:		.asciiz " "
average: 	.asciiz "Average of maximum and minimum is: " 
it_is:		.asciiz "It is equal to the sum of elements "
with_indexes:   .asciiz " with indexes "
and_other:	.asciiz " and "
no_solution:	.asciiz "No two elements have been found to sum to the average"
set_of_numbers: .word 0
.align 2

.text
.globl main

main:
# ask and store the quantity of numbers
li	$v0, 4
la	$a0, ask_string
syscall
li	$v0, 5
syscall
move	$a0, $v0
# $a0 stores the quantity of numbers

jal check_quantity
jal ask_for_numbers
jal get_and_print_maximum
# New Line
li	$v0, 11
li	$a0, 10
syscall
jal get_and_print_minimum
li	$v0, 11
li	$a0, 10
syscall
jal get_and_print_avg
li	$v0, 11
li	$a0, 10
syscall
jal get_numbers_that_sum_to_avg


# End execution
li	$v0, 10
syscall

#############################################################
## Check limit for quantity of numbers, > 0, < 50
#############################################################

check_quantity:

	greater_than_zero: 
		bgtz $a0, less_than_51
		j wrong_number
	less_than_51:  
		blt $a0, 51, valid_number
		j wrong_number
	valid_number:
		jr $ra
	wrong_number:
		li $v0, 4
		la $a0, wrong_input
		syscall		
		li $v0, 10
		syscall
		


#############################################################
### Ask for numbers - these will be stored in memory
#############################################################

ask_for_numbers:

	li $a1, 0 # $a1 is the iterator
	li $a2, 0
	la $s0, set_of_numbers
	move $a3, $a0 # a3 is the number of integers to be asked 
	
	loop: 
		bge 	$a1, $a3, end
		# ask and store a number
		li	$v0, 4
		la	$a0, ask_number
		syscall
		li	$v0, 5	
		syscall

		add 	$t1, $a2, $s0
		sw	$v0, 0($t1)  # s0 is base address , $v0 written number
		addi	$a2, $a2, 4 # a2 is the offset 
		addi	$a1, $a1, 1 # increment counter
		j loop
		
	end:
		jr $ra
	
#############################################################
### Get maximum number of the array
#############################################################

get_and_print_maximum:

	li $t0 0
	li $t1 0
	li $t2 0
	li $t3 0  # Maximum value will be stored here
	mul $a3, $a3, 4
	printloop: 
		bge $t0 $a3 endprint
		add $t1 $t0 $s0
		lw $t2 0($t1)
		bgt $t3 $t2 else      # compare element with local maximum 
		move $t3 $t2
	else:	
		addi $t0 $t0 4
		j printloop
	endprint:
		# Print maximum element	
		la $a0 maximum
		li $v0 4
		syscall
		move $t8 $t3  # Save contents to later on calculate the avg
		move $a0 $t3
		li $v0 1
		syscall
		jr $ra


#############################################################
### Get minimum number of the array
#############################################################

get_and_print_minimum:

	li $t0 0
	li $t1 0
	li $t2 0
	li $t3 2147483647  # Minimum value will be stored here - initial should be maximum integer 32bits
	
	printminloop: 
		bge $t0 $a3 endprintmin
		add $t1 $t0 $s0
		lw $t2 0($t1)
		blt $t3 $t2 elsemin      # compare element with local minimum 
		move $t3 $t2
	elsemin:	
		addi $t0 $t0 4
		j printminloop
	endprintmin:
		# Print minimum element	
		la $a0 minimum
		li $v0 4
		syscall
		move $t9 $t3 # Save contents to later on calculate the avg
		move $a0 $t3
		li $v0 1
		syscall
		jr $ra
		
#############################################################
### Get avg between max and min
#############################################################

get_and_print_avg:

	la 	 $a0 average
	li	 $v0 4
	syscall
	li	 $a0 0
	add	 $a0 $t8 $t9
	div	 $a0 $a0 2 
	li 	 $v0 1
	syscall
	move 	 $s1 $a0 # save avg for later
	jr $ra
	 

#############################################################
### Get two numbers that sum to avg
### s1 is avg
#############################################################

get_numbers_that_sum_to_avg:

	li $t0 0  # Iterator for first loop
	li $t1 0  
	li $t2 0  # First element to be compared
	li $t3 0  # First number will be stored here
	li $t4 0  # Second number will be stored here
	li $t5 0  # Iterator for second loop
	li $t6 0  # Second number to be compared
	li $t8 0  # This will be set to 1 when the solution is found
	firstloop: 
		bge $t0 $a3 endfirstloop
		add $t1 $t0 $s0
		lw $t2 0($t1)
		li  $t5 0
		move $t5 $t0  # Save status t0 to a1 to use it as an offset in the inner loop
		addi $t5 $t5 4  # This avoids comparing the number with itself
	secondloop:
		bge $t5 $a3 endloop
		add $t1 $t5 $s0
		lw  $t6 0($t1)
		add $t7 $t2 $t6  	 # add numbers to be compared
		beq $t7 $s1 success      # compare element with sum 
		addi $t5 $t5 4
		j secondloop
	endloop:
		addi $t0 $t0 4
		j firstloop
	endfirstloop:
		# Print maximum element	
		la $a0 no_solution
		li $v0 4
		syscall
		jr $ra
	success:
		la $a0 it_is
		li $v0 4
		syscall
		move $a0 $t2
		li $v0 1
		syscall
		la $a0 and_other
		li $v0 4
		syscall
		move $a0 $t6
		li $v0 1
		syscall
		la $a0 with_indexes
		li $v0 4
		syscall
		div $a0 $t0 4
		addi $a0 $a0 1
		li $v0 1
		syscall
		la $a0 and_other
		li $v0 4
		syscall
		div $a0 $t5 4
		addi $a0 $a0 1
		li $v0 1
		syscall
		jr $ra
		
