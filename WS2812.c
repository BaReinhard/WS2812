int *data[24];
void setup(){
  DDRB = B11111111;
  PORTB = B00000000;
 for(int i = 0;i<24;i++)
  data[i] = new int(1);
}

void loop(){
  send_bytes(data,24);
}

void nsecDelay(long nsecs){
  unsigned long counter;
  counter = nsecs/6.25;
  asm volatile(
    "loop&=:\n\t"
    "nop\n\t"
    "dec %0\n\t"
    "brne loop\n\t"
     :"=r"(counter)
    );
}

void send_bytes(int **data, int data_len){
    for(int i=0;i < 8;i++)
      send_bit_red(data[i]); 
    for(int i=8;i < 16;i++)
      send_bit_blue(data[i]);
    for(int i=16;i < 24;i++)
      send_bit_green(data[i]);
}

void send_bit_red(int bi){
  if(bi){
  PORTB = B00000100;
  delayMicroseconds(30);
  PORTB = B00000000;
  delayMicroseconds(1000);
  return;
  }
  else{
  PORTB = B00000100;
  delayMicroseconds(3);
  PORTB = B00000000;
  delayMicroseconds(1000);
  return;
  }
}
void send_bit_green(int bi){
  if(bi){
  PORTB = B00010000;
  delayMicroseconds(30);
  PORTB = B00000000;
  delayMicroseconds(1000);
  return;
  }
  else{
  PORTB = B00000100;
  delayMicroseconds(3);
  PORTB = B00000000;
  delayMicroseconds(1000);
  return;
  }
}
void send_bit_blue(int bi){
  if(bi){
  PORTB = B00001000;
  delayMicroseconds(30);
  PORTB = B00000000;
  delayMicroseconds(1000);
  return;
  }
  else{
  PORTB = B00000100;
  delayMicroseconds(3);
  PORTB = B00000000;
  delayMicroseconds(1000);
  return;
  }
}
