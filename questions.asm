Question 1:

1.subi    $t2, $t3, 5 
#
# R[rt] = R[rs] SignExtImm 
#

2.rpt     $t2, loop    
#
#    if (R[rs]>0)  
#        R[rs]=R[rs] ‐1  
#    else 
#        PC= PC + 4 + BranchAddr 
# 
 
For each instruction in the table above find the shortest sequence of MIPS instructions that perform 
the same operation 

1. 
Subi is not needed in MIPS since addi could be used to perform the same operation adding a negative number. Hence:

addi $t2 $t3 -5


2. 
Assuming R[rs] means a certain register - let us write $s0 for the sake of simplicity

beginloop:
    bltz $s0 endloop 
else:
    addi pc pc 4
    mul  $t0 $t0 4      #Assuming t0 is the offset
    addi pc pc $t0
endloop:
    addi $s0 $s0 -1
    

Question 2:

The following figure shows the placement of a bit field in register $ t0. 

31                  i                   j               0
                            Field                           
    31-i bits               i-j bits            j bits

In the following problem, you will be asked to write MIPS instruction to extract the bits Field from 
$t0 and place them into $t1 at the location indicated in the following table

31                          i-j               0
        000...000                   Field                           
        31-i-j bits                 i-j bits
    
Find the shortest sequence of MIPS instructions that extracts a field from $t0 for the constant values 
i=22 and j = 5 and places the field into $t1 in the format shown in the data table. (hint:  your answer 
should not contains more than 6 instructions).  

a. 

31                          17               0
        000...000                   Field                           
        14 bits                    17 bits
                                                
The way to tackle this problem is to bitwise and the register with a mask and then shift the wanted bits

li  $t1 0x3FFFF
and $t1 $t0 $t1

There is no need to shift the bits to the right as the field was already in the right, now the solution is in $t1

b.

31                         14               0
        Field                    000...000                      
        17 bits                    14 bits     

li 	$t1  0xffffc000
and	$t1 $t0 $t1  
srl	$t1 $t1 14 

As in the previous problem first we set the mask to the first 14 bits, then the numbers are shifted 14 bits to the right
to get what "field" is


Question 3:

The following problem refers to a function f that calls another function func. 
The function declaration for func is   
    
int func(int a, int b)
 
int f(int  a,  int  b,  int c,  int  d) { 
    if(a+b>c+d)   
        return func(a+b, c+d); 
    return  func (c+d, a+b);  
} 
 
Write this function in MIPS

$a registers should be used as arguments so $a0 = a, $a1 = b, $a2 = c, $a3 = d
$v registers should be used to store return values

f:
    add $t0 $a0 $a1    #a+b
    add $t1 $a2 $a3    #c+d
    beginif:
        bgt $t0 $t1 endif
        # Pass arguments to func
        move $a0 $t1
        move $a1 $t0
        jal func
        # If func complies with MIPS calling convention, result should be in $v0
        jr $ra # return back, leaving the result of func(c+d, a+b) in $v0
    endif:
        # Pass arguments to func
        move $a0 $t0
        move $a1 $t1
        jal func
        # If func complies with MIPS calling convention, result should be in $v0
        jr $ra # return back, leaving the result of func(c+d, a+b) in $v0
