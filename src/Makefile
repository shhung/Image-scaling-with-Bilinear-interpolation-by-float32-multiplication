TOOL = riscv-none-elf-
ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv
OPTIMIZE = -O3

%.o: %.S
	$(TOOL)as -R $(ASFLAGS) -o $@ $<

all: ImgScale.elf ImgScaleFromC.elf

ImgScale.elf: ImgScale.o
	$(TOOL)ld -o $@ -T ImgScale.ld $(LDFLAGS) $<

ImgScaleFromC.elf: ImgScale.c
	$(TOOL)gcc -o $@ $(ASFLAGS) $<

clean:
	$(RM) ImgScale.elf ImgScaleFromC.elf ImgScale.o