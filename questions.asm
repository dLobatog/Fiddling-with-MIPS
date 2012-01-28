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
    


