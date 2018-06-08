all:	trip.hex

clean:
	rm -f *.asm *.pre *.lss *.lst *.obj *.hex *.map
	
trip.asm:	bcd.f beeper.f cpu.f delay.f ds1307.f eeprom.f i2cmaster.f key.f lcd.f lcdinout.f time.f trip.f twi.f
	..\avrforth trip.f
	
trip.hex:	trip.asm
	..\..\bintools\avrasm2 trip.asm -l trip.lst -I .. -m trip.map -v0 -fI
