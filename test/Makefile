TOOL = riscv-none-elf-
ASFLAGS = -march=rv32i -mabi=ilp32

%.o: %.S
	$(TOOL)as $(ASFLAGS) -o $@ $<

%.o: %.c
	$(TOOL)gcc -c $(ASFLAGS) -o $@ $<

all: main.elf

main.elf: add.o main.o
	$(TOOL)gcc -o $@ *.o

clean:
	$(RM) main.elf *.o