;************************************
; written by: 1o_o7 
; revised by: BaReinhard
; date: <2014|10|29>
; revision_date: <2017|12|28>
; version: 1.0
; file saved as: blink.asm
; for AVR: atmega328p
; clock frequency: 16MHz (optional)
;************************************

; Program funcion:---------------------
; Able to control a WS2812 led/strand
; Simply send a byte of 1's and 0's 
; depending on color desired, 24 bits per
; WS2812 chip
;--------------------------------------

.nolist
.include "./m328Pdef.inc"
.list

;==============
; Declarations:

.def temp = r16
.def overflows = r17
.def counter = r22

.def TLD = r18 ; needs 9.6 cycles = 4 = 255-4 = 251 0b11111011
.def T0H = r19 ; needs 5.6 cycles = 2 = 255-2 = 253 0b11111101
.def T1H = r20 ; needs 11.2 cycles = 5 = 255-5 = 250 0b11111010
.def TLL = r21 ; needs 96 cycles = 45 = 255-45 = 210 0b11010110
.def repeat = r23

.org 0x0000              ; memory (PC) location of reset handler
rjmp Reset               ; jmp costs 2 cpu cycles and rjmp costs only 1
                         ; so unless you need to jump more than 8k bytes
                         ; you only need rjmp. Some microcontrollers therefore only 
                         ; have rjmp and not jmp
.org 0x0020              ; memory location of Timer0 overflow handler
rjmp overflow_handler    ; go here if a timer0 overflow interrupt occurs 
clr TLD
clr counter
clr T0H
clr T1H
clr TLL
clr repeat
ldi TLD,0b11110110
ldi T0H,0b11111101
ldi T1H,0b11111010
ldi TLL,0b11011010
;============

Reset: 
   ldi temp,  0b00000001 
   out TCCR0B, temp      ; Set Clock Selector Bit CS00, CS01, CS02 to 001
                         ; this puts the Timer Counter0, TCNTO in FCPU/ mode, no prescaler
                         ; so it ticks at the CPU freq
         
   
   
   ; Set Timer ----------------------------------
   
   

   ; Set Timer/Counter to 0 ---------------------
   ;ldi temp, 0b00000000
   ;out TCNT0, temp       ; initialize the Timer/Counter to 128

   sbi DDRB, 2           ; Set Pin 10 to Output
   sbi DDRB, 3           ; Set Pin 11 to Output
   sbi DDRB, 4           ; Set Pin 12 to Output
     

;======================
; Main body of program:
Jump_second:
  rjmp second_set
Main:
  clr counter
  first_set:
  rcall GREEN
  inc counter
  cpi counter, 1
  brne first_set
  breq second_set
GREEN:
; G BYTE-----------------  
    rcall T_1
    rcall T_0
    rcall T_1
    rcall T_0
    rcall T_0
    rcall T_0
    rcall T_0
    rcall T_0
    
  ; R BYTE------------------
    rcall T_0 ;1
    rcall T_0 ;2
    rcall T_0 ;3
    rcall T_0 ;4
    rcall T_0 ;5
    rcall T_0 ;6
    rcall T_1 ;7
    rcall T_0 ;8
  ; B BYTE-------------------

    rcall T_0
    rcall T_0
    rcall T_0
    rcall T_0
    rcall T_1
    rcall T_0
    rcall T_0
    rcall T_1
    ret
RED:
  ; G BYTE-----------------  
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  
; R BYTE------------------
  rcall T_1 ;1
  rcall T_1 ;2
  rcall T_1 ;3
  rcall T_1 ;4
  rcall T_1 ;5
  rcall T_1 ;6
  rcall T_1 ;7
  rcall T_1 ;8
; B BYTE-------------------

  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  ret
second_set:
  rcall RED
  inc counter
  cpi counter,2
  brne second_set
  breq third_set
  MAGENTA:
  ;cpi repeat,5
  ;brne PC+2 
  ;ldi repeat, 0
  ;breq third_set
  ; G BYTE-----------------  
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
; R BYTE------------------
  rcall T_1 ;1
  rcall T_1 ;2
  rcall T_0 ;3
  rcall T_0 ;4
  rcall T_0 ;5
  rcall T_0 ;6
  rcall T_1 ;7
  rcall T_0 ;8
; B BYTE-------------------

  rcall T_1
  rcall T_1
  rcall T_1
  rcall T_1
  rcall T_0
  rcall T_0
  rcall T_0
  rcall T_0
  ret
third_set:
  rcall MAGENTA
  inc counter
  cpi counter,3
  brne third_set
  inc repeat
  cpi repeat, 19
  brne first_jump
  rcall END
  jmp Main

first_jump:
  jmp Main

END:
  cbi PORTB, 3            ; Set Low
  rcall delay_TLL         ; Wait 6000ns
  ret

T_1:
    sbi PORTB, 3          ; Set High
    rcall delay_T1H       ; Wait 700ns
    cbi PORTB, 3          ; Set Low
    rcall delay_TLD       ; Wait 600ns
    ret           

T_0:
  sbi PORTB, 3            ; Set high
  rcall delay_T0H         ; Wait 350ns
  cbi PORTB, 3            ; Set Low
  rcall delay_TLD         ; Wait 600ns
  ret

delay_T1H:
  nop
  nop                     ; Delay 8 cycles
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
  ret  
delay_TLL:
   ldi temp, 0b00000001   
   sts TIMSK0, temp       ; set the Timer Overflow Interrupt Enable (TOIE0) 0th bit 
                          ; of the Timer Interrupt Mask Register (TIMSK0)
   sei                    ; enable global interrupts -- equivalent to "sbi SREG, I"
   out TCNT0, TLL         ; set timer byte (TCNT0) to TLL 255-(number of overflows/cycles needed)
   clr overflows          ; clear overflows byte to 0
   sec_count:
      cpi overflows,1     ; compare number of overflows 1
   brne sec_count         ; branch to back to sec_count if not equal 
   cli                    ; disable global interrupts
   ldi temp, 0b00000000   ;
   sts TIMSK0, temp       ; disable timer overflow interupts 
                          ; (possibly unnecessary, due to disabling global interupt)
   ret 

overflow_handler: 
   inc overflows    
   reti                  ; return from interrupt
        ; add 1 to the overflows variable
   ;cpi overflows, 1     ; compare with 1
   ;brne PC+2            ; Program Counter + 2 (skip next line) if not equal
   ;clr overflows
