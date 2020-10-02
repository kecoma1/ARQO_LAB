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
  addi $t1, $t2, 100     # t1 = 2 + 100 = 102
  addi $t2, $t1, 50      # t2 = 102 + 50 = 152
  addi $t3, $t3, 6       # t3 = 4 + 6 = 10
  addi $t6, $t6, 32      # t6 = 32 + 32 = 64

  lw $t1, 0($zero)       # t1 = 1
  lw $t2, 0($zero)       # t2 = 1
  
  # realiza operaciones
  add $t7, $t1, $t2 # t7 = 102 + 152 = 254
  add $s0, $t3, $t4 # s0 = 10 + 8 = 18
  sub $t1, $t1, $t1 # t1 = 0
  sub $t2, $t2, $t2 # t2 = 0
  addi $t2, $t2, 1  # t2 = 1 
  xor $s1, $t1, $t2 # s1 = 1
  and $s3, $t1, $t2 # s3 = 0
  addi $t1, $t1, 1  # t1 = 1
  and $s4, $t1, $t2 # s4 = 1
  or $s5, $t1, $t2  # s5 = 1
  sub $t1, $t1, $t1 # t1 = 0
  or $s1, $t2, $t2  # s1 = 1
  or $s6, $s3, $t1  # s6 = 0
  slt $s7, $t1, $t2 # s7 = 1
  slti $s0, $t7, 1  # s0 = 0
  
  # carga datos inmediatos en la parte alta de registros
  lw $t1, 0($zero)  # lw $r9,  0($r0)  -> r9  = 1
  lw $t2, 4($zero)  # lw $r10, 4($r0)  -> r10 = 2
  lui $t1, 1 # lui $r9, 1  -> queda a 65536  (0x00010000)
  lui $t2, 2 # lui $r10, 2 -> queda a 131072 (0x00020000)
  
  nop
  nop
  nop
  nop
  beq $s1, $s2, salto # beq $r17, $r18, salto -> como $r17=$r18=3, salta
  nop
  nop
  lw $t1, 44($zero)  # t1 = 32 
salto:
  sub $t1, $t1, $t1     # t1 = 0
  beq $t1, $t2, nosalto # beq $r19, $r20, nosalto -> este branch NO debe ejecutarse
final:
  beq $zero, $zero, final # -> bucle infinito, volvera aqui tras varios NOPs.
  nop
  nop
  nop
  nop
nosalto:
  lui $t2, 0xFFFF  # lui $r10, 0xFFFF -> no debe ejecutarse
  beq $zero, $zero, final
  nop
  nop
  nop
  nop
  
  

