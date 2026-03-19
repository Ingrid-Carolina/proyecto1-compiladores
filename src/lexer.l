%{
#include <stdio.h>
#include <string.h>
#include "../build/parser.tab.h"

void showError();
int line = 1;

extern void save_token(const char *s);

#define TOK(fmt, ...) do { \
    char _b[256]; \
    snprintf(_b, sizeof(_b), fmt, ##__VA_ARGS__); \
    save_token(_b); \
} while(0)
%}

numbers     ([0-9])+(\.[0-9]+)?
alpha       ([a-zA-Z_][a-zA-Z0-9_]*)
whitespace  [ \t\r]+
newline     [\n]

%%

{newline}          { line++; }
{whitespace}       { }
"fn"               { TOK("[TOKEN] FN          (linea %d)", line); return FN; }
"let"              { TOK("[TOKEN] LET         (linea %d)", line); return LET; }
"mut"              { TOK("[TOKEN] MUT         (linea %d)", line); return MUT; }
"if"               { TOK("[TOKEN] IF          (linea %d)", line); return IF; }
"else"             { TOK("[TOKEN] ELSE        (linea %d)", line); return ELSE; }
"while"            { TOK("[TOKEN] WHILE       (linea %d)", line); return WHILE; }
"for"              { TOK("[TOKEN] FOR         (linea %d)", line); return FOR; }
"return"           { TOK("[TOKEN] RETURN      (linea %d)", line); return RETURN; }
"in"               { TOK("[TOKEN] IN          (linea %d)", line); return IN; }
"true"             { TOK("[TOKEN] IDENTIFIER  (linea %d): true",  line); yylval.n = strdup(yytext); return IDENTIFIER; }
"false"            { TOK("[TOKEN] IDENTIFIER  (linea %d): false", line); yylval.n = strdup(yytext); return IDENTIFIER; }
"{"                { TOK("[TOKEN] LBRACE      (linea %d)", line); return LBRACE; }
"}"                { TOK("[TOKEN] RBRACE      (linea %d)", line); return RBRACE; }
"("                { TOK("[TOKEN] LPAREN      (linea %d)", line); return LPAREN; }
")"                { TOK("[TOKEN] RPAREN      (linea %d)", line); return RPAREN; }
";"                { TOK("[TOKEN] SEMICOLON   (linea %d)", line); return SEMICOLON; }
","                { TOK("[TOKEN] COMMA       (linea %d)", line); return COMMA; }
"=="               { TOK("[TOKEN] EQ          (linea %d)", line); return EQ; }
"!="               { TOK("[TOKEN] NEQ         (linea %d)", line); return NEQ; }
"="                { TOK("[TOKEN] ASSIGN      (linea %d)", line); return ASSIGN; }
"<"                { TOK("[TOKEN] LT          (linea %d)", line); return LT; }
">"                { TOK("[TOKEN] GT          (linea %d)", line); return GT; }
"+"                { TOK("[TOKEN] PLUS        (linea %d)", line); return PLUS; }
"->"               { TOK("[TOKEN] ARROW       (linea %d)", line); return ARROW; }
"-"                { TOK("[TOKEN] MINUS       (linea %d)", line); return MINUS; }
"*"                { TOK("[TOKEN] MUL         (linea %d)", line); return MUL; }
"/"                { TOK("[TOKEN] DIV         (linea %d)", line); return DIV; }
"&&"               { TOK("[TOKEN] AND         (linea %d)", line); return AND; }
"%"                { TOK("[TOKEN] MOD         (linea %d)", line); return MOD; }
"i32"              { TOK("[TOKEN] I32         (linea %d)", line); return I32; }
"f64"              { TOK("[TOKEN] F64         (linea %d)", line); return F64; }
"bool"             { TOK("[TOKEN] BOOL        (linea %d)", line); return BOOL; }
"char"             { TOK("[TOKEN] CHAR_TYPE   (linea %d)", line); return CHAR_TYPE; }
"str"              { TOK("[TOKEN] STR_TYPE    (linea %d)", line); return STR_TYPE; }
":"                { TOK("[TOKEN] COLON       (linea %d)", line); return COLON; }
"//".*             { TOK("[TOKEN] COMMENT     (linea %d): %s", line, yytext); }
{alpha}            { TOK("[TOKEN] IDENTIFIER  (linea %d): %s", line, yytext); yylval.n = strdup(yytext); return IDENTIFIER; }
{numbers}          { TOK("[TOKEN] NUMBER      (linea %d): %s", line, yytext); yylval.number = atof(yytext); return NUMBER; }
\'([^\'\\]|\\.)*\' { TOK("[TOKEN] CHAR        (linea %d): %s", line, yytext); yylval.n = strdup(yytext); return CHAR; }
\"([^\"\\]|\\.)*\" { TOK("[TOKEN] STRING      (linea %d): %s", line, yytext); yylval.n = strdup(yytext); return STRING; }
.                  { showError(); return OTHER; }

%%

void showError() {
    char b[256];
    snprintf(b, sizeof(b), "[ERROR LEXICO] Caracter no reconocido en linea %d: '%s'", line, yytext);
    save_token(b);
}
int yywrap() { return 1; }
