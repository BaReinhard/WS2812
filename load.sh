#!/bin/bash

dir=`ls /dev | grep cu.usbmodem | head -1`
avr-gcc -c -O3 -w -mmcu=atmega328p -DF_CPI=1000000L WS2812.s -o WS2812.s.o
avr-gcc -c -O3 -w -mmcu=atmega328p -DF_CPI=1000000L WS2812.cpp -o WS2812.cpp.o
avr-gcc -Os -Wl,--gc-sections -mmcu=atmega328p WS2812.cpp.o WS2812.s.o -o image.elf
avr-objcopy -Oihex -R.eeprom image.elf image.hex
avrdude -p m328p -c stk500v1 -b 115200 -P /dev/$dir -U flash:w:image.hex -F