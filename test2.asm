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
    blt t0, zero, done     # t0 < 0, done
    addi t1, t1, 1         #  t1++
    slli t0, t0, 1         #  t0 shift left
    addi t2, t2, -1        #  t2--
    beq t2, zero, done1     #   t2 < 0, done
    beq zero, zero, loop
done1:
	add s2, t1, zero

#-----------case2---------------#
case2:
	add a7, zero, zero   # a7 = 0
input2_1:
	ecall
	bne zero, a0, input2_1	  # if a0 != 0, hold
input2_2:
	ecall
	beq zero, a0, input2_2   #  if a0 == 0, hold
	addi a7, zero, 5           # a7=5 read 8bit signed  !!!!!!!!!
	ecall
	addi t0, a0, 0    # t0 = input
	 
	andi t2, t0, 0x7C00  # t2 is expo
	srli t2, t2, 10    
	addi t2, t2, -15    # sub bias
	blt t2, zero, is_zero # if expo < 0, then output is 0
	addi t3, t2, 10   
	andi t4, t0, 0x03FF  # t4 is frac
	ori t4, t4, 0x0400    # t4 add 1
	sll t4, t4, t2    # real integer part
	beq zero, zero, end_shift
is_zero:
	addi t4, zero, 0
end_shift:
	addi t5, t4, 0   # t5 = t4
	andi t6, t4, 0x03FF   # t6 is frac without adding 1
	bne t6, zero, round_up  # if t6 != 0, then t5++
	beq zero, zero, done2		
round_up:
	addi t5, t5, 1		
done2:
	# how to judge negative????
	
	
