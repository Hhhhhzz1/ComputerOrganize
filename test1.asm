.data
.text

# a7=0 read confirm
# a7=1 read 8bit signed
# a7=2 read testcase
# a7=3 read 8bit unsigned
# a7=4 write 16bit to led

#a7=5 write shuma


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
addi a1,a0,0
addi a7,zero,0
output01_1:
ecall
bne zero,a0,output01_1 #set confirm to 0 to display output
output01_2:
addi a7,zero,4
addi a0,a1,0
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
addi a2,a0,0
addi a7,zero,0
output02_1:
ecall
bne zero,a0,output02_1 #set confirm to 0 to display output
output02_2:
addi a7,zero,4
addi a0,a2,0
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
addi a1,a0,0
sw a0,0(zero) #write input to mem[0]
addi a7,zero,0
output11_1:
ecall
bne zero,a0,output11_1 #set confirm to 0 to display output
output11_2:
addi a7,zero,4
addi a0,a1,0
ecall #write reg a0 to led
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
addi a1,a0,0
sw a0,4(zero) #write input to mem[1]
addi a7,zero,0
output21_1:
ecall
bne zero,a0,output21_1 #set confirm to 0 to display output
output21_2:
addi a7,zero,4
addi a0,a1,0
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output21_2 #set confirm to 1 to continue


beq zero,zero,readtestcase
##testcase 3
case3:
lw a1,0(zero)
addi zero,zero,0
lw a2,4(zero)
beq a1,a2,light3
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
light3:
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

##testcase 4
case4:
lw a1,0(zero)
lw a2,4(zero)
blt a1,a2,light4
addi a7,zero,0
output42_1:
ecall
bne zero,a0,output42_1 #set confirm to 0 to display output
output42_2:
addi a7,zero,4
addi a0,zero,0 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output42_2 #set confirm to 1 to continue

beq zero,zero,readtestcase
light4:
addi a7,zero,0
output41_1:
ecall
bne zero,a0,output41_1 #set confirm to 0 to display output
output41_2:
addi a7,zero,4
addi a0,zero,1 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output41_2 #set confirm to 1 to continue

beq zero,zero,readtestcase

##testcase 5
case5:
lw a1,0(zero)
lw a2,4(zero)
bge a1,a2,light5
addi a7,zero,0
output52_1:
ecall
bne zero,a0,output52_1 #set confirm to 0 to display output
output52_2:
addi a7,zero,4
addi a0,zero,0 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output52_2 #set confirm to 1 to continue

beq zero,zero,readtestcase
light5:
addi a7,zero,0
output51_1:
ecall
bne zero,a0,output51_1 #set confirm to 0 to display output
output51_2:
addi a7,zero,4
addi a0,zero,1 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output51_2 #set confirm to 1 to continue

beq zero,zero,readtestcase

##testcase 6
case6:
lw a1,0(zero)
lw a2,4(zero)
bltu a1,a2,light6
addi a7,zero,0
output62_1:
ecall
bne zero,a0,output62_1 #set confirm to 0 to display output
output62_2:
addi a7,zero,4
addi a0,zero,0 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output62_2 #set confirm to 1 to continue

beq zero,zero,readtestcase
light6:
addi a7,zero,0
output61_1:
ecall
bne zero,a0,output61_1 #set confirm to 0 to display output
output61_2:
addi a7,zero,4
addi a0,zero,1 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output61_2 #set confirm to 1 to continue

beq zero,zero,readtestcase



##testcase 7
case7:
lw a1,0(s2)
lw a2,4(s2)
bgeu a1,a2,light
addi a7,zero,0
output72_1:
ecall
bne zero,a0,output72_1 #set confirm to 0 to display output
output72_2:
addi a7,zero,4
addi a0,zero,0 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output72_2 #set confirm to 1 to continue

beq zero,zero,readtestcase
light:
addi a7,zero,0
output71_1:
ecall
bne zero,a0,output71_1 #set confirm to 0 to display output
output71_2:
addi a7,zero,4
addi a0,zero,1 
ecall #write reg a0 to led
addi a7,zero,0
ecall
beq a0,zero,output71_2 #set confirm to 1 to continue

beq zero,zero,readtestcase
