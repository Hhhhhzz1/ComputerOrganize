.data
.text

# a7=0 read confirm
# a7=1 read 8bit signed
# a7=2 read testcase
# a7=3 read 8bit unsigned
# a7=4 write 16bit to led

#a7=5 write shuma
## read input1 ##
add s2,zero,zero
addi a7,zero,0
input1_1:
ecall
bne zero,a0,input1_1
input1_2:
ecall
beq zero,a0,input1_2
addi a7,zero,1  #00000001?ffffffff
ecall
addi a1,a0,0 #a1=input1
####------####


##read input2##
addi a7,zero,0
input2_1:
ecall
bne zero,a0,input2_1
input2_2:
ecall
beq zero,a0,input2_2
addi a7,zero,1
ecall
addi a2,a0,0 #a2=input2

####------####

readtestcase:
##read testcase##
addi a7,zero,0
readtest_1:
ecall
bne zero,a0,readtest_1
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
addi s1,s1,1
beq s0,s1,case8
beq zero,zero,readtestcase

##testcase 0
case0:
## read input1 ##
addi a7,zero,0
input01_1:
ecall
bne zero,a0,input01_1
input01_2:
ecall
beq zero,a0,input01_2
addi a7,zero,1  
ecall #read input
addi a7,zero,0
output01_1:
ecall
bne zero,a0,output01_1 #set confirm to 0 to display output
output01_2:
addi a7,zero,4
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output01_2  #set confirm to 1 to continue


####------####


##read input2##
addi a7,zero,0
input02_1:
ecall
bne zero,a0,input02_1
input02_2:
ecall
beq zero,a0,input02_2
addi a7,zero,1
ecall #read input
addi a7,zero,0
output02_1:
ecall
bne zero,a0,output02_1 #set confirm to 0 to display output
output02_2:
addi a7,zero,4
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output02_2  #set confirm to 1 to continue

beq zero,zero,readtestcase

##testcase 1
case1:
## read input1 ##
addi a7,zero,0
input11_1:
ecall
bne zero,a0,input11_1
input11_2:
ecall
beq zero,a0,input11_2
addi a7,zero,1  
ecall #read input
sw a0,0(s2) #write input to mem[0]
addi a7,zero,0
output11_1:
ecall
bne zero,a0,output11_1 #set confirm to 0 to display output
output11_2:
addi a7,zero,5
ecall #write reg a0 to shuma
addi a7,zero,0
ecall
beq a0,zero,output11_2 #set confirm to 1 to continue



beq zero,zero,readtestcase
##testcase 2
case2:
## read input1 ##
addi a7,zero,0
input21_1:
ecall
bne zero,a0,input21_1
input21_2:
ecall
beq zero,a0,input21_2
addi a7,zero,3 
ecall #read input
sw a0,1(s2) #write input to mem[1]
addi a7,zero,0
output21_1:
ecall
bne zero,a0,output21_1 #set confirm to 0 to display output
output21_2:
addi a7,zero,5
ecall #write reg a0 to shuma
addi a7,zero,0
ecall
beq a0,zero,output21_2 #set confirm to 1 to continue

beq zero,zero,readtestcase
##testcase 3
case3:
lw a1,0(s2)
lw a2,1(s2)
beq a1,a2,light
addi a7,zero,0
output32_1:
ecall
bne zero,a0,output32_1 #set confirm to 0 to display output
output32_2:
addi a7,zero,4
addi a0,zero,0 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output32_2 #set confirm to 1 to continue
beq zero,zero,readtestcase
light:
addi a7,zero,0
output31_1:
ecall
bne zero,a0,output31_1 #set confirm to 0 to display output
output31_2:
addi a7,zero,4
addi a0,zero,1 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output31_2 #set confirm to 1 to continue
beq zero,zero,readtestcase

