TOOL = riscv-none-elf-
ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

%.o: %.S
	$(TOOL)as -R $(ASFLAGS) -o $@ $<

all: ImgScale.elf

ImgScale.elf: ImgScale.o
	 $(TOOL)ld -o $@ -T ImgScale.ld $(LDFLAGS) $<

clean:
	$(RM) ImgScale.elf ImgScale.o