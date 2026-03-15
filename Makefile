# Tools
ASM = uasm
CC  = gcc

# Flags
ASMFLAGS = -I./Irvine -zcw -elf

# Config
TARGET  = asm-trig
MODULES = main sine-n cosine-n square-float eval-sin-cos pide-radianes \
	convierte-rango eval-grados pide-grados imprime-grados tabla-grados

OBJS = $(addsuffix .o, $(MODULES))

# Rules
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -m32 $(OBJS) -o $(TARGET) -L./irvingt -l:irvingt.a

%.o: %.asm
	$(ASM) $(ASMFLAGS) -Fo=$@ $<

clean:
	rm -f *.o $(TARGET)

