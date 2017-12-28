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
; counts off seconds by blinking an LED
;
; PD4 ---> LED ---> R(330 ohm) ---> GND
;
;--------------------------------------

.nolist
.include "./m328Pdef.inc"
.list

;==============
; Declarations:

.def temp = r16
.def overflows = r17


.org 0x0000              ; memory (PC) location of reset handler
rjmp Reset               ; jmp costs 2 cpu cycles and rjmp costs only 1
                         ; so unless you need to jump more than 8k bytes
                         ; you only need rjmp. Some microcontrollers therefore only 
                         ; have rjmp and not jmp
.org 0x0020              ; memory location of Timer0 overflow handler
rjmp overflow_handler    ; go here if a timer0 overflow interrupt occurs 

;============

Reset: 
   ldi temp,  0b00000001 
   out TCCR0B, temp      ; Set Clock Selector Bit CS00, CS01, CS02 to 001
                         ; this puts the Timer Counter0, TCNTO in FCPU/ mode, no prescaler
                         ; so it ticks at the CPU freq
         
   ldi temp, 0b00000001
   
   
   ; Set Timer ----------------------------------
   
   sts TIMSK0, temp      ; set the Timer Overflow Interrupt Enable (TOIE0) bit 
                         ; of the Timer Interrupt Mask Register (TIMSK0)

   sei                   ; enable global interrupts -- equivalent to "sbi SREG, I"


   ; Set Timer/Counter to 0 ---------------------
   ldi temp, 0b10000000
   out TCNT0, temp       ; initialize the Timer/Counter to 128

   sbi DDRB, 2           ; set PD4 to output

;======================
; Main body of program:
Main:
  rcall T_1
  rcall T_0
  rcall T_1
  rcall T_1
  rcall T_0
  rcall T_1
  rcall T_0
  rcall T_0
  rjmp Main
  
T_1:
   sbi PORTB, 2          ; turn on LED on PD4
   rcall delay_800       ; delay will be 800 nanoseconds
   cbi PORTB, 2          ; turn off LED on PD4
   rcall delay_300       ; delay will be 300 nanoseconds
   ret           

T_0:
  sbi PORTB, 2
  rcall delay_300
  cbi PORTB, 2
  rcall delay_800
  ret

delay_800:
   ldi temp, 0b11001111
   out TCNT0, temp       ; initialize the Timer/Counter to 207
   clr overflows         ; set overflows to 0 
   sec_count_1:
     cpi overflows,1    ; compare number of overflows and 30
   brne sec_count_1        ; branch to back to sec_count if not equal 
   ret
   
delay_300:
   ldi temp, 0b10000000
   out TCNT0, temp       ; initialize the Timer/Counter to 128
   clr overflows         ; set overflows to 0 
   sec_count:
      cpi overflows,1    ; compare number of overflows and 30
   brne sec_count        ; branch to back to sec_count if not equal 
   ret  

overflow_handler: 
   inc overflows         ; add 1 to the overflows variable
   ;cpi overflows, 1     ; compare with 1
   ;brne PC+2            ; Program Counter + 2 (skip next line) if not equal
   ;clr overflows
   ; if 61 overflows occured reset the counter to zero
   reti                  ; return from interrupt
