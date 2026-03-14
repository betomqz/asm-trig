# Tools
ASM = uasm
CC  = gcc

# Flags
ASMFLAGS = -I./Irvine -zcw -elf

# Config
TARGET  = asm-trig
MODULES = main cosine-n square-float

OBJS = $(addsuffix .o, $(MODULES))

# Rules
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -m32 $(OBJS) -o $(TARGET) -L./irvingt -l:irvingt.a

%.o: %.asm
	$(ASM) $(ASMFLAGS) -Fo=$@ $<

clean:
	rm -f *.o $(TARGET)

