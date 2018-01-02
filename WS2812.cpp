#include <avr/io.h>
#include <util/delay.h>
int data[96];
void delay_T0H(){
 asm volatile("nop\n\t"); 
};
struct GRB{
  int g[8];
  int r[8]; 
  int b[8];
};
class WS2812{
  public:
  WS2812(){
    for(int i=0;i<8;i++){
      _grb.g[i]=1;
      _grb.r[i]=1;
      _grb.b[i]=1;
    }
  }
  GRB _grb;
};
void init_blue(int data[],int data_len, int start);
void init_green(int data[],int data_len, int start);
void init_red(int data[],int data_len, int start);
void init_white(int data[],int data_len, int start);
void send_bytes(int data[],int data_len);
void send_bit(int bi);
void init_blue(WS2812 ws);
void init_green(WS2812 ws);
void init_red(WS2812 ws);
void init_white(WS2812 ws);
void send_bytes(WS2812 ws);
extern "C" void delay_T1H();
extern "C" void delay_TLD();

int main(){
  WS2812 ws;
  init_white(ws);
  DDRB = 0b11111111;
  PORTB = 0b00000000;
  send_bytes(ws);
}
void init_white(WS2812 ws){
  for(int i = 0;i<8;i++){
    ws._grb.r[i]=1;
    ws._grb.g[i]=1;
    ws._grb.b[i]=1;
    
  }
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
void send_bytes(WS2812 ws){
  for(int z = 0;z<16;z++){
    for(int i=0;i < 8;i++){
      send_bit(ws._grb.g[i]);
    } 
    for(int i=0;i < 8;i++){
      send_bit(ws._grb.r[i]);
    }
    for(int i=0;i < 8;i++){
      send_bit(ws._grb.b[i]);
    }
  }
    PORTB = 0b00000000;
    _delay_ms(.6);
    send_bytes(ws);
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
