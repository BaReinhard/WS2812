#include <avr/io.h>
#include <util/delay.h>
int data[24];

void delay_T0H(){
 asm volatile("nop\n\t"); 
};
extern void delay_T1H();
extern void delay_TLD();

int main(){
  for(int i=0 ; i<24 ; i++){
  if(i>16)
  data[i] = 0;
  else
  data[i] = 1;
}
DDRB = 0b11111111;
PORTB = 0b00000000;
send_bytes(data,24);
}



void send_bytes(int data[], int data_len){
  for(int z = 0;z<32;z++){
    for(int i=0;i < data_len;i++){
      send_bit(data[i]);
    } 
  }
    PORTB = 0b00000000;
    _delay_ms(6);
    send_bytes(data,data_len);
}

void send_bit(int bi){
  if(bi==1){
  PORTB = 0b00000100;
  delay_T1H();  
  }
  else{
  PORTB = 0b00000100;
  delay_T0H();  
  }
  PORTB = 0b00000000;
  delay_TLD();
}
