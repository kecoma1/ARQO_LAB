.data 0
num0:  .word 1  # posic 0
num1:  .word 2  # posic 4
num2:  .word 4  # posic 8 
num3:  .word 8  # posic 12 
num4:  .word 16 # posic 16 
num5:  .word 32 # posic 20
num6:  .word 0  # posic 24
num7:  .word 0  # posic 28
num8:  .word 0  # posic 32
num9:  .word 0  # posic 36
num10: .word 0  # posic 40
num11: .word 0  # posic 44

.text 0
main:
  # carga num0 a num5 en los registros 9 a 14
  lw $t1, 0($zero)  # lw $r9,  0($r0)  -> r9  = 1
  lw $t2, 4($zero)  # lw $r10, 4($r0)  -> r10 = 2
  lw $t3, 8($zero)  # lw $r11, 8($r0)  -> r11 = 4 
  lw $t4, 12($zero) # lw $r12, 12($r0) -> r12 = 8 
  lw $t5, 16($zero) # lw $r13, 16($r0) -> r13 = 16
  lw $t6, 20($zero) # lw $r14, 20($r0) -> r14 = 32
  
  add $t3, $t1, $t1
  beq $t3, $t2, executes_branch # JUMPS
  lw $t1, 20($zero)  # lw $r9,  0($r0)  -> r9  = 32
  lw $t2, 20($zero)  # lw $r10, 4($r0)  -> r10 = 32
  lw $t3, 20($zero)  # lw $r11, 8($r0)  -> r11 = 32 
  lw $t4, 20($zero) # lw $r12, 12($r0) -> r12 = 32 
  lw $t5, 20($zero) # lw $r13, 16($r0) -> r13 = 32
  lw $t6, 20($zero) # lw $r14, 20($r0) -> r14 = 32
executes_branch:
  add $t3, $t3, $t3
  beq $t3, $t2, executes_branch # DOESN'T JUMP
  lw $t3, 4($zero)  # lw $r11, 4($r0)  -> r11 = 2
  beq $t3, $t2, executes_branch2 # JUMPS
  lw $t1, 20($zero)  # lw $r9,  0($r0)  -> r9  = 32
  lw $t2, 20($zero)  # lw $r10, 4($r0)  -> r10 = 32
  lw $t3, 20($zero)  # lw $r11, 8($r0)  -> r11 = 32 
  lw $t4, 20($zero) # lw $r12, 12($r0) -> r12 = 32 
  lw $t5, 20($zero) # lw $r13, 16($r0) -> r13 = 32
  lw $t6, 20($zero) # lw $r14, 20($r0) -> r14 = 32
executes_branch2:
  add $t4, $t4, $t4
  lw $t3, 8($zero)  # lw $r11, 8($r0)  -> r11 = 4
  beq $t3, $t2, executes_branch2 # DOESN'T JUMP
  lw $t1, 20($zero)  # lw $r9,  0($r0)  -> r9  = 32
  lw $t2, 20($zero)  # lw $r10, 4($r0)  -> r10 = 32
  lw $t3, 20($zero)  # lw $r11, 8($r0)  -> r11 = 32 
  lw $t4, 20($zero) # lw $r12, 12($r0) -> r12 = 32 
  lw $t5, 20($zero) # lw $r13, 16($r0) -> r13 = 32
  lw $t6, 20($zero) # lw $r14, 20($r0) -> r14 = 32
  lw $t1, 0($zero)  # lw $r9,  0($r0)  -> r9  = 1
  lw $t2, 4($zero)  # lw $r10, 4($r0)  -> r10 = 2
  beq $t1, $t2, executes_branch2 # DOESN'T JUMP
  beq $t1, $t1, executes_branch2 # JUMP

  
  

  
  
  