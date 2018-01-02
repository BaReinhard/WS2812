#!/bin/bash
dir=`ls /dev | grep cu.usbmodem | head -1`
avra WS2812.asm && avrdude -p m328p -c stk500v1 -b 115200 -P /dev/$dir -U flash:w:image.hex -F
