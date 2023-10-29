TOOL = riscv-none-elf-
ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv
OPTIMIZE = -Ofast

all: main.elf ImgScaleFromC.elf

%.o: %.S
	$(TOOL)as $(ASFLAGS) -o $@ $<

main.o: main.c
	$(TOOL)gcc $(OPTIMIZE) -c $(ASFLAGS) -o $@ $<

main.elf: ImgScale.o main.o
	$(TOOL)gcc -o $@ *.o

ImgScaleFromC.elf: ImgScale.c
	$(TOOL)gcc $(OPTIMIZE) -o $@ $(ASFLAGS) $<

clean:
	$(RM) main.elf ImgScaleFromC.elf *.o