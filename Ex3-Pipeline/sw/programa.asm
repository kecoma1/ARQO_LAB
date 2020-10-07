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
  # copia num0 a num5 sobre num6 a num11
  sw $t1, 24($zero) # sw $r9,  24($r0) -> data[24] =  1
  sw $t2, 28($zero) # sw $r10, 28($r0) -> data[28] =  2
  sw $t3, 32($zero) # sw $r11, 32($r0) -> data[32] =  4 
  sw $t4, 36($zero) # sw $r12, 36($r0) -> data[36] =  8 
  sw $t5, 40($zero) # sw $r13, 40($r0) -> data[40] =  16
  sw $t6, 44($zero) # sw $r14, 44($r0) -> data[44] =  32
  
  # carga num6 a num11 en los registros 9 a 14, deberia ser lo mismo
  addi $t1, $t2, 100     # (r9)t1 = 102
  sub $t2, $t1, $t1      # (r9)t2 = 0
  nop
  nop
  nop
  nop
  nop
  lw $t1, 0($zero)       # (r9)t1 = 1
  lw $t2, 0($zero)       # (r10)t2 = 1
  
  # realiza operaciones
  nop
  nop
  nop
  nop
  nop
  add $t3, $t1, $t2 # (r11)t3 = 1 
  xor $t4, $t1, $t2 # (r12)t4 = 0 
  and $t5, $t1, $t2 # (r13)t5 = 1
  or $t6, $t1, $t2  # (r14)t1 = 1
  sub $t7, $t1, $t1 # (r15)t1 = 0
  lw $t3, 0($zero)  # (r11)t3 = 1
  slt $t4, $t2, $t1 # (r12)t4 = 0
  slt $t5, $t1, $t2 # (r13)t5 = 1
  nop
  nop
  nop
  nop
  nop
  slti $t6, $t4, 10 # (r14)t6 = 1
  slti $t7, $t4, 0  # (r15)t7 = 0
  
  # carga datos inmediatos en la parte alta de registros
  lw $t1, 0($zero)  # lw $r9,  0($r0)  -> r9  = 1
  lw $t2, 4($zero)  # lw $r10, 4($r0)  -> r10 = 2
  lui $t3, 1 # lui $r11, 1  -> queda a 65536  (0x00010000)
  lui $t6, 2 # lui $r14, 1 -> queda a 65536 (0x00010000)
  nop
  nop
  nop
  nop
  nop
  
  beq $t1, $t2, salto # doesn't execute
  nop
  nop
  nop
  nop
  nop
  lw $t1, 0($zero)  # lw $r9,  0($r0)  -> r9  = 1
  lw $t2, 0($zero)  # lw $r10, 4($r0)  -> r10 = 1
  nop
  nop
  nop
  nop
  nop
  
  beq $t1, $t2, salto # Jumps
  nop
  nop
  lw $t1, 44($zero)  # t1 = 32  (doesn't execute)
salto:
  nop
  nop
  nop
  nop
  nop
  sub $t2, $t1, $t1     # t2 = 0
  j final
prueba:
  nop
  nop
  nop
  nop
  nop
  lw $t1, 20($zero) # doesn't execute t1 = 16
final:
  nop
  nop
  nop
  nop
  j final
nosalto:
  lui $t2, 0xFFFF  # lui $r10, 0xFFFF -> no debe ejecutarse
  beq $zero, $zero, final
  nop
  nop
  nop
  nop
