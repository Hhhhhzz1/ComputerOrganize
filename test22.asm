.text
readtestcase:
addi s10,zero,1
##read testcase##
addi a7,zero,0
readtest_1:
ecall
beq s10,a0,readtest_1
readtest_2:
ecall
beq zero,a0,readtest_2
addi a7,zero,2
ecall
addi s0,a0,0
####--------####

addi s1,zero,0
##cases##
beq s0,s1,case0
addi s1,s1,1
beq s0,s1,case1
addi s1,s1,1
beq s0,s1,case2
addi s1,s1,1
beq s0,s1,case3
addi s1,s1,1
beq s0,s1,case4
addi s1,s1,1
beq s0,s1,case5
addi s1,s1,1
beq s0,s1,case6
addi s1,s1,1
beq s0,s1,case7
beq zero,zero,readtestcase

#--------the code before case1 need to be written, such as how to select case i. (such as: a7==2)
#---------case1-----------#
case0:
	add s2, zero, zero   # s2 = 0,   s2 store the answer
	add a7, zero, zero   # a7 = 0
input1_1:
	ecall
	beq s10, a0, input1_1	  # if a0 != 0, hold
input1_2:
	ecall
	beq zero, a0, input1_2   #  if a0 == 0, hold
	addi a7, zero, 1           # a7=1 read 8bit signed
	ecall
	addi t0, a0, 0
	slli t0,t0,24    # t0 = input
	
	add t1, zero, zero   # counter
	addi t2, zero, 8      # t2 = 8, control the length of loop
loop:
    blt t0, zero, done1     # t0 < 0, done
    addi t1, t1, 1         #  t1++
    slli t0, t0, 1         #  t0 shift left
    addi t2, t2, -1        #  t2--
    beq t2, zero, done1     #   t2 < 0, done
    beq zero, zero, loop
done1:
	add s2, t1, zero
	
addi a7,zero,0
output01_1:
ecall
beq s10,a0,output01_1 #set confirm to 0 to display output
output01_2:
addi a7,zero,4
addi a0,s2,0
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output01_2  #set confirm to 1 to continue
beq zero,zero,readtestcase


#-----------case2---------------#
case1:

	addi a7, zero, 0       # a7=0
input2_high_1:
	ecall                  
	beq s10, a0, input2_high_1  # if not zero, hold
input2_high_2:
	ecall
	beq zero, a0, input2_high_2  # if zero, hold
	addi a7, zero, 3       # a7=3, read 8bit unsigned
	ecall
	slli t0, a0, 8         # store high 8 bits to t0


	addi a7, zero, 0       # a7=0
input2_low_1:
	ecall                  
	beq s10, a0, input2_low_1   # if not zero, hold
input2_low_2:
	ecall                   
	beq zero, a0, input2_low_2  # if zero, hold
	addi a7, zero, 3       # a7=3, read 8bit unsigned
	ecall
	or t0, t0, a0         # store low 8 bits to t0,   the orginal input is stored in lower 16 bits in t0

	lui t1, 32768
	and t1, t0, t1   # t1 store the sign bit(0x8000 = 32768)
    srli t1, t1, 15       # move to the lowest
	
	lui t2, 31744
	srli t2, t2, 15
	and t2, t0, t2
	   
	srli t2, t2, 10        # t2 store the expo part  (lower bits)
	addi t2, t2, -15       # sub bias
	andi t3, t0, 1023    # t3 store the frac part  (lower bits)
	ori t3, t3, 1024     #   add 1 in the begining


	blt t2, zero, is_zero2   # if t2 < 0
	beq t2, zero, is_zero2     #  if t2 == 0

	sll t4, t3, t2         # t4 store the integer part
	beq zero, zero check_fraction2

is_zero2:
	addi t4, zero, 0       # t4 = 0
	beq zero, zero check_sign2

check_fraction2:
	andi t5, t0, 1023    # t5 store frac part
	beq t5, zero, check_sign2   # if   t5 == 0,  not round
	addi t4, t4, 1         #  else , round, i.e t4++

check_sign2:
	beq t1, zero, positive2 # if t1 (sign bit) == 0, then positive
	xori t4, t4, -1             # else   neg t4
	addi t4, t4, 1

positive2:
	addi a7,zero,0
output21_1:
ecall
beq s10,a0,output21_1 #set confirm to 0 to display output
output21_2:
addi a7,zero,4
addi a0,t4,0
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output21_2 #set confirm to 1 to continue


beq zero,zero,readtestcase
	
	           
	                      
#------------------case3------------------#
case2:
    addi a7, zero, 0       # a7=0
input3_high_1:
    ecall                  
    beq s10, a0, input3_high_1  # if not zero, hold
input3_high_2:
    ecall
    beq zero, a0, input3_high_2  # if zero, hold
    addi a7, zero, 3       # a7=3, read 8bit unsigned
    ecall
    slli t0, a0, 8         # store high 8 bits to t0

    addi a7, zero, 0       # a7=0
input3_low_1:
    ecall                  
    beq s10, a0, input3_low_1   # if not zero, hold
input3_low_2:
    ecall                   
    beq zero, a0, input3_low_2  # if zero, hold
    addi a7, zero, 3       # a7=3, read 8bit unsigned
    ecall
    or t0, t0, a0         # store low 8 bits to t0, the original input is stored in lower 16 bits in t0

    lui t1, 32768
	and t1, t0, t1   # t1 store the sign bit(0x8000 = 32768)
    srli t1, t1, 15       # move to the lowest
    
    
	lui t2, 31744
	srli t2, t2, 15
	and t2, t0, t2
    
    srli t2, t2, 10        # t2 store the expo part (lower bits)
    addi t2, t2, -15       # sub bias
    andi t3, t0, 1023    # t3 store the frac part (0x03FF = 1023)
    ori t3, t3, 1024     # add 1 in the beginning (0x0400 = 1024)

    blt t2, zero, is_zero3  # if t2 < 0
    beq t2, zero, is_zero3  # if t2 == 0

    sll t4, t3, t2         # t4 store the integer part
    beq zero, zero  check_fraction3

is_zero3:
    addi t4, zero, 0       # t4 = 0
    beq zero, zero check_sign3

check_fraction3:
    andi t5, t0, 1023    # t5 store frac part (0x03FF = 1023)
    beq t5, zero, check_sign3  # if t5 == 0, not round
    
    # Modify to floor operation
    bne t1, zero, check_sign3  # if t1 (sign bit) != 0, then positive,  skip rounding for negative numbers
    addi t4, t4, -1         # else negative and fraction part != 0, floor (t4 - -)

check_sign3:
    beq t1, zero, positive3  # if t1 (sign bit) == 0, then positive
    # Handle negative numbers without using neg
    xori t4, t4, -1         # else neg t4 
    addi t4, t4, 1          

positive3:
   addi a7,zero,0
output31_1:
ecall
beq s10,a0,output31_1 #set confirm to 0 to display output
output31_2:
addi a7,zero,4
addi a0,t4,0 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output31_2 #set confirm to 1 to continue

beq zero,zero,readtestcase  
               
	                                            
	                                                                                  
	                                                                                                                        
#---------------case4-------------------#
case3:
    addi a7, zero, 0       # a7=0
input4_high_1:
    ecall                  
    beq s10, a0, input4_high_1  # if not zero, hold
input4_high_2:
    ecall
    beq zero, a0, input4_high_2  # if zero, hold
    addi a7, zero, 3       # a7=3, read 8bit unsigned
    ecall
    slli t0, a0, 8         # store high 8 bits to t0

    addi a7, zero, 0       # a7=0
input4_low_1:
    ecall                  
    beq s10, a0, input4_low_1   # if not zero, hold
input4_low_2:
    ecall                   
    beq zero, a0, input4_low_2  # if zero, hold
    addi a7, zero, 3       # a7=3, read 8bit unsigned
    ecall
    or t0, t0, a0         # store low 8 bits to t0, the original input is stored in lower 16 bits in t0

	lui t1, 32768
	and t1, t0, t1   # t1 store the sign bit(0x8000 = 32768)
    srli t1, t1, 15       # move to the lowest
    
    
	lui t2, 31744
	srli t2, t2, 15
	and t2, t0, t2
	
    srli t2, t2, 10        # t2 store the expo part (lower bits)
    addi t2, t2, -15       # sub bias
    andi t3, t0, 1023    # t3 store the frac part (0x03FF = 1023)
    ori t3, t3, 1024     # add 1 in the beginning (0x0400 = 1024)

    blt t2, zero, is_zero4  # if t2 < 0
    beq t2, zero, is_zero4  # if t2 == 0

    sll t4, t3, t2         # t4 store the integer part
    beq zero, zero check_fraction4

is_zero4:
    addi t4, zero, 0       # t4 = 0
    beq zero, zero check_sign4

check_fraction4:
    andi t5, t0, 1023    # t5 store frac part (0x03FF = 1023)
    slli t6, t5, 1         # Shift left to get the rounding bit
    
    lui a3, 1
    slli a3, a3, 11 
    and t6, t6, a3      # Isolate the rounding bit (0x0800 = 2048)

    beq t6, zero, check_sign4  # if rounding bit is 0, skip rounding
    bne t1, zero, round_down4  # if negative, round down
    addi t4, t4, 1            # if positive, round up
    beq zero, zero check_sign4

round_down4:
    addi t4, t4, -1            # if negative, round down

check_sign4:
    beq t1, zero, positive4    # if t1 (sign bit) == 0, then positive

    # Handle negative numbers without using neg
    xori t4, t4, -1           # else neg t4 
    addi t4, t4, 1            #

positive4:
   addi a7,zero,0
output41_1:
ecall
beq s10,a0,output41_1 #set confirm to 0 to display output
output41_2:
addi a7,zero,4
addi a0,t4,0 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output41_2 #set confirm to 1 to continue

beq zero,zero,readtestcase

case4:
## read input1 ##
addi a7,zero,0
input51_1:
ecall
beq s10,a0,input51_1
input51_2:
ecall
beq zero,a0,input51_2
addi a7,zero,3  
ecall #read input
addi a1,a0,0 #move input1 to a1

## read input2 ##
addi a7,zero,0
input52_1:
ecall
beq s10,a0,input52_1
input52_2:
ecall
beq zero,a0,input52_2
addi a7,zero,3  
ecall #read input
addi a2,a0,0 #move input2 to a2
add a3,a1,a2
andi a5,a3,255  #take low 8bit 1_0111_0110
srli a4,a3,8 
add a3,a4,a5  #0111_0110
xori a3,a3,-1
andi a3,a3,255
addi a7,zero,0
output51_1:
ecall
beq s10,a0,output51_1 #set confirm to 0 to display output
output51_2:
addi a7,zero,4
addi a0,a3,0
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output51_2  #set confirm to 1 to continue
ecall

beq zero,zero,readtestcase

case5:
## read input1 ##
addi a7,zero,0
input61_1:
ecall
beq s10,a0,input61_1
input61_2:
ecall
beq zero,a0,input61_2
addi a7,zero,3  
ecall #read input
addi a1,a0,0 #move input1 to a1 low 8bit

## read input2 ##
addi a7,zero,0
input62_1:
ecall
beq s10,a0,input62_1
input62_2:
ecall
beq zero,a0,input62_2
addi a7,zero,3 
ecall #read input
addi a2,a0,0 #move input2 to a2  4bit

slli a1,a1,8
add a3,a2,a1 #12bit input

addi a7,zero,0
output61_1:
ecall
beq s10,a0,output61_1 #set confirm to 0 to display output
output61_2:
addi a7,zero,4
addi a0,a3,0
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output61_2  #set confirm to 1 to continue
ecall
beq zero,zero,readtestcase

case6:
## read input1 ##
addi a7,zero,0
input71_1:
ecall
beq s10,a0,input71_1
input71_2:
ecall
beq zero,a0,input71_2
addi a7,zero,3 
ecall #read input
addi s2,a0,0 #s2=input
addi s3,zero,0 #s3=fib(n)
addi s4,zero,0 #s4=stack count
addi s5,zero,1 #i
addi sp,zero,0
loop6:
bge s3,s2,outloop6
addi a0,s5,0
jal fib
addi s3,a0,0
addi s5,s5,1 #i++
beq zero,zero,loop6
outloop6:

output72_1:
addi a7,zero,0
ecall
beq s10,a0,output72_1  #set confirm 0 to display
output72_2:
addi a7,zero,4
addi a0,s5,-2
ecall
addi a7,zero,0
ecall
beq a0,zero,output72_2 #set confirm 1 to continue


output71_1:
addi a7,zero,0
ecall
beq s10,a0,output71_1  #set confirm 0 to display
output71_2:
addi a7,zero,4
addi a0,s4,0
ecall
addi a7,zero,0
ecall
beq a0,zero,output71_2 #set confirm 1 to continue


beq zero,zero,readtestcase

case7:
## read input1 ##
addi a7,zero,0
input81_1:
ecall
beq s10,a0,input81_1
input81_2:
ecall
beq zero,a0,input81_2
addi a7,zero,3 
ecall #read input
addi s2,a0,0 #s2=input
addi s3,zero,0 #s3=fib(n)
addi s5,zero,1 #i
addi sp,zero,0
loop7:
bge s3,s2,outloop7
addi a1,s5,0
jal fib1
addi s3,a1,0
addi s5,s5,1 #i++
beq zero,zero,loop7
outloop7:

output82_1:
addi a7,zero,0
ecall
beq s10,a0,output82_1  #set confirm 0 to display
output82_2:
addi a7,zero,4
addi a0,s5,-2
ecall
addi a7,zero,0
ecall
beq a0,zero,output82_2 #set confirm 1 to continue





beq zero,zero,readtestcase
#a1 canshu
fib:
addi s4,s4,1 ## in stack
addi sp,sp,8
sw a1,-4(sp)
sw ra,-8(sp)
addi t1,zero,3
bge a1,t1,L1
addi a1,zero,1
addi sp,sp,-8
addi s4,s4,1 ## out stack
jalr zero,0(ra)

L1:

addi a1,a1,-1
jal fib
addi sp,sp,4
sw a1,-4(sp)
lw t2,-8(sp)
addi a1,t2,-2
jal fib
lw t1,-4(sp)
add a1,a1,t1
lw ra,-12(sp)
addi sp,sp,-12
addi s4,s4,1 ## out stack
jalr zero,0(ra)



#a0 canshu
fib1:
output81_1:
addi a7,zero,0
ecall
beq s10,a0,output81_1  #set confirm 0 to display
output81_2:
addi a7,zero,4
addi a0,a1,0
ecall
addi a7,zero,0
ecall
beq a0,zero,output81_2 #set confirm 1 to continue

addi sp,sp,8
sw a1,-4(sp)
sw ra,-8(sp)
addi t1,zero,3
bge a1,t1,L11
addi a1,zero,1
addi sp,sp,-8
jalr zero,0(ra)

L11:

addi a1,a1,-1
jal fib1
addi sp,sp,4
sw a1,-4(sp)
lw t2,-8(sp)
addi a1,t2,-2
jal fib1
lw t1,-4(sp)
add a1,a1,t1
lw ra,-12(sp)
addi sp,sp,-12
jalr zero,0(ra)

