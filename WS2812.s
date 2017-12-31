
.globl delay_T0H
.globl delay_T1H
.globl delay_TLD

.section .text
delay_T1H:
  nop
  nop 
  nop
  nop                    
  ret

delay_T0H:
  ret                    ; Delay 1 Cycle
   
delay_TLD:
  nop                     ; Delay 10 Cycles
  nop
  nop
  nop
  nop 
  nop
  nop
  nop
  nop
  nop
  nop
  ret  
.end