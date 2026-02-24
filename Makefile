CC=gcc
CFLAGS=-Wall -g
TARGET=rust_compiler

all:
	@echo "Proyecto listo para compilar con Flex y Bison"

clean:
	rm -rf build/
