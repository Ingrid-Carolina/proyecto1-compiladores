#!/bin/bash
    clear
echo "============INICIO DE ANALISIS============"
    flex lexer.l
    bison -d parser.y
    gcc -o main parser.tab.c lex.yy.c -lfl
    ./main < test.rs
echo "============ANALISIS COMPLETADO============"