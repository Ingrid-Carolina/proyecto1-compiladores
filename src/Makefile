CC = g++
CFLAGS = -std=c++11 -Wall -I. -Wno-register

default:
    @clear
    flex -l lexer.l
    bison -dv parser.y
    gcc -o main parser.tab.c lex.yy.c -lfl

clean:
    rm -f main parser.tab.c parser.tab.h parser.output lex.yy.c