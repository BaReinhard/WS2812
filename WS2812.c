#include <avr/io.h>
#include <util/delay.h>
int data[96];
void delay_T0H(){
 asm volatile("nop\n\t"); 
};
extern void delay_T1H();
extern void delay_TLD();

int main(){
  init_blue(data,24,0);
  init_red(data,48,24);
  init_green(data,72,48);
  init_white(data,96,72);
  DDRB = 0b11111111;
  PORTB = 0b00000000;
  send_bytes(data,96);
}
void init_white(int data[],int data_len, int start){
  for(int i=start ; i<data_len ; i++)
  data[i]=1;
  
}
void init_red(int data[], int data_len, int start){
  for(int i=start ; i<data_len ; i++){
  if(i>=start+8 && i <=start+15)
  data[i] = 1;
  else
  data[i] = 0;
}
}
void init_green(int data[], int data_len,int start){
  for(int i=start ; i<data_len ; i++){
  if(i<start+8)
  data[i] = 1;
  else
  data[i] = 0;
}
}
void init_blue(int data[], int data_len,int start){
  for(int i=start ; i<data_len ; i++){
  if(i >=start+16)
  data[i] = 1;
  else
  data[i] = 0;
}
}

void send_bytes(int data[], int data_len){
  for(int z = 0;z<16;z++){
    for(int i=0;i < data_len;i++){
      send_bit(data[i]);
    } 
  }
    PORTB = 0b00000000;
    _delay_ms(.6);
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
