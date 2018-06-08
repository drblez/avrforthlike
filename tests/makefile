all:	t_arithm.hex

clean:
	rm -f *.asm *.pre *.lss *.lst *.obj *.hex *.map *.npre
	
t_arithm.asm:	t_arithm.f
	..\avrforth t_arithm.f
	
t_arithm.hex:	t_arithm.asm
	..\..\bintools\avrasm2 t_arithm.asm -l t_arithm.lst -I .. -m t_arithm.map -v0 -fI
