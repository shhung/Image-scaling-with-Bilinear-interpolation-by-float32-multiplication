TOOL = riscv-none-elf-
ASFLAGS = -march=rv32i -mabi=ilp32
OBJECTS := $(patsubst %.S,%.o,$(wildcard *.S))

%.o: %.S
	$(TOOL)as $(ASFLAGS) -o $@ $<

%.o: %.c
	$(TOOL)gcc -c $(ASFLAGS) -o $@ $<

all: main.elf

main.elf: main.o $(OBJECTS)
	$(TOOL)gcc -o $@ *.o

clean:
	$(RM) main.elf *.o