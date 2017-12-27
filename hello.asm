
.nolist
.include "./m328Pdef.inc"
.list
.def temp =r16
.def count = r26

  clr r24
  ldi temp,0b11111111
  out DDRB,temp
  out PORTB, temp
  ldi count,999
  
  
loop:
call Green
  call Delay
  call Blue
  call Delay
  call Red
  call DelayLong
  call DelayLong
  call DelayLong
dec count
brne loop

Init: 


  
  call Red
  
  
  
  jmp Init
  
Green:
  ldi temp, 0b0011000
  out DDRB, temp
  out PORTB, temp ; Set Pin 11 High
  ret
Blue:
  ldi temp,0b0010000
  out DDRB,temp
  out PORTB, temp ; Set Pin 12 High
  ret
Red:
  ldi temp,0b0000100
  out DDRB,temp ; Set Pin 10 High
  out PORTB, temp
  ret
Delay:
  nop
  nop
  nop
  nop

DelayLong:
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


  Main:
     
   jmp    Main 
