.data 
.text


#--------the code before case1 need to be written, such as how to select case i. (such as: a7==2)
#---------case1-----------#
case1:
	add s2, zero, zero   # s2 = 0,   s2 store the answer
	add a7, zero, zero   # a7 = 0
input1_1:
	ecall
	bne zero, a0, input1_1	  # if a0 != 0, hold
input1_2:
	ecall
	beq zero, a0, input1_2   #  if a0 == 0, hold
	addi a7, zero, 1           # a7=1 read 8bit signed
	ecall
	addi t0, a0, 0    # t0 = input
	
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




#-----------case2---------------#
case2:

	addi a7, zero, 0       # a7=0
input2_high_1:
	ecall                  
	bne zero, a0, input2_high_1  # if not zero, hold
input2_high_2:
	ecall
	beq zero, a0, input2_high_2  # if zero, hold
	addi a7, zero, 3       # a7=3, read 8bit unsigned
	ecall
	slli t0, a0, 8         # store high 8 bits to t0


	addi a7, zero, 0       # a7=0
input2_low_1:
	ecall                  
	bne zero, a0, input2_low_1   # if not zero, hold
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
	addi a7, zero, 4       # a7=4
	addi a0, t4, 0         #  a0 = t4
	ecall       
	
	           
	                      
#------------------case3------------------#
case3:
    addi a7, zero, 0       # a7=0
input3_high_1:
    ecall                  
    bne zero, a0, input3_high_1  # if not zero, hold
input3_high_2:
    ecall
    beq zero, a0, input3_high_2  # if zero, hold
    addi a7, zero, 3       # a7=3, read 8bit unsigned
    ecall
    slli t0, a0, 8         # store high 8 bits to t0

    addi a7, zero, 0       # a7=0
input3_low_1:
    ecall                  
    bne zero, a0, input3_low_1   # if not zero, hold
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
    addi a7, zero, 4       # a7=4
    addi a0, t4, 0         # a0 = t4
    ecall                 
               
	                                            
	                                                                                  
	                                                                                                                        
#---------------case4-------------------#
case4:
    addi a7, zero, 0       # a7=0
input4_high_1:
    ecall                  
    bne zero, a0, input4_high_1  # if not zero, hold
input4_high_2:
    ecall
    beq zero, a0, input4_high_2  # if zero, hold
    addi a7, zero, 3       # a7=3, read 8bit unsigned
    ecall
    slli t0, a0, 8         # store high 8 bits to t0

    addi a7, zero, 0       # a7=0
input4_low_1:
    ecall                  
    bne zero, a0, input4_low_1   # if not zero, hold
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
    addi a7, zero, 4          # a7=4
    addi a0, t4, 0            # a0 = t4
    ecall                     # 输出取整后的结果
