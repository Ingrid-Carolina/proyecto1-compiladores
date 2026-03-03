%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
void showError();
int line = 1; // Variable para contar líneas
%}

numbers     ([0-9])+(\.[0-9]+)?
alpha       ([a-zA-Z_][a-zA-Z0-9_]*)
whitespace  [ \t\r]+
newline     [\n]

%%

{newline}          { line++; /* Incrementar contador de líneas */ }
{whitespace}       { /* Ignorar espacios en blanco */ }
"fn"               { printf("[TOKEN] FN (línea %d)\n", line); return FN; }
"let"              { printf("[TOKEN] LET (línea %d)\n", line); return LET; }
"mut"              { printf("[TOKEN] MUT (línea %d)\n", line); return MUT; }
"if"               { printf("[TOKEN] IF (línea %d)\n", line); return IF; }
"else"             { printf("[TOKEN] ELSE (línea %d)\n", line); return ELSE; }
"while"            { printf("[TOKEN] WHILE (línea %d)\n", line); return WHILE; }
"for"              { printf("[TOKEN] FOR (línea %d)\n", line); return FOR; }
"return"           { printf("[TOKEN] RETURN (línea %d)\n", line); return RETURN; }
"in"               { printf("[TOKEN] IN (línea %d)\n", line); return IN; }
"true"             { printf("[TOKEN] IDENTIFIER (línea %d): true\n", line); yylval.name = strdup(yytext); return IDENTIFIER; }
"false"            { printf("[TOKEN] IDENTIFIER (línea %d): false\n", line); yylval.name = strdup(yytext); return IDENTIFIER; }
"{"                { printf("[TOKEN] LBRACE (línea %d)\n", line); return LBRACE; }
"}"                { printf("[TOKEN] RBRACE (línea %d)\n", line); return RBRACE; }
"("                { printf("[TOKEN] LPAREN (línea %d)\n", line); return LPAREN; }
")"                { printf("[TOKEN] RPAREN (línea %d)\n", line); return RPAREN; }
";"                { printf("[TOKEN] SEMICOLON (línea %d)\n", line); return SEMICOLON; }
","                { printf("[TOKEN] COMMA (línea %d)\n", line); return COMMA; }
"="                { printf("[TOKEN] ASSIGN (línea %d)\n", line); return ASSIGN; }
"=="               { printf("[TOKEN] EQ (línea %d)\n", line); return EQ; }
"!="               { printf("[TOKEN] NEQ (línea %d)\n", line); return NEQ; }
"<"                { printf("[TOKEN] LT (línea %d)\n", line); return LT; }
">"                { printf("[TOKEN] GT (línea %d)\n", line); return GT; }
"+"                { printf("[TOKEN] PLUS (línea %d)\n", line); return PLUS; }
"-"                { printf("[TOKEN] MINUS (línea %d)\n", line); return MINUS; }
"*"                { printf("[TOKEN] MUL (línea %d)\n", line); return MUL; }
"/"                { printf("[TOKEN] DIV (línea %d)\n", line); return DIV; }
"->"               { printf("[TOKEN] ARROW (línea %d)\n", line); return ARROW; }
"&&"               { printf("[TOKEN] AND (línea %d)\n", line); return AND; }
"%"                { printf("[TOKEN] MOD (línea %d)\n", line); return MOD; }
"i32"              { printf("[TOKEN] I32 (línea %d)\n", line); return I32; }
"f64"              { printf("[TOKEN] F64 (línea %d)\n", line); return F64; }
"bool"             { printf("[TOKEN] BOOL (línea %d)\n", line); return BOOL; }
"char"             { printf("[TOKEN] CHAR_TYPE (línea %d)\n", line); return CHAR_TYPE; }
"str"              { printf("[TOKEN] STR_TYPE (línea %d)\n", line); return STR_TYPE; }
":"                { printf("[TOKEN] COLON (línea %d)\n", line); return COLON; }
"//".*             { printf("[TOKEN] COMMENT (línea %d): %s\n", line, yytext); /* Ignorar comentarios */ }
{alpha}            { printf("[TOKEN] IDENTIFIER (línea %d): %s\n", line, yytext); yylval.name = strdup(yytext); return IDENTIFIER; }
{numbers}          { printf("[TOKEN] NUMBER (línea %d): %s\n", line, yytext); yylval.number = atof(yytext); return NUMBER; }
\'([^\'\\]|\\.)\'  { printf("[TOKEN] CHAR (línea %d): %s\n", line, yytext); yylval.name = strdup(yytext); return CHAR; }
\"([^\"\\]|\\.)*\" { printf("[TOKEN] STRING (línea %d): %s\n", line, yytext); yylval.name = strdup(yytext); return STRING; }
.                  { showError(); return OTHER; }

%%

void showError(){
    printf("Error léxico: caracter no reconocido en línea %d: '%s'\n", line, yytext);
}
int yywrap(){
    return 1;
}