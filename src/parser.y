%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
int yyerror(char *s);
extern int line;
extern char* yytext;
%}

%union {
    char *name;
    double number;
}

%token <name> IDENTIFIER STRING CHAR
%token <number> NUMBER
%token FN LET MUT IF ELSE WHILE FOR RETURN IN 
%token LBRACE RBRACE LPAREN RPAREN SEMICOLON COMMA ASSIGN EQ NEQ LT GT PLUS MINUS MUL DIV
%token ARROW AND MOD I32 F64 BOOL CHAR_TYPE STR_TYPE COLON
%token OTHER

%left AND
%left EQ NEQ
%left LT GT
%left PLUS MINUS
%left MUL DIV MOD

%%

program:
    stmts
;

stmts:
    /* vacío */
    | stmt stmts
;

stmt:
    function
    | declaration SEMICOLON
    | if_stmt
    | return_stmt SEMICOLON
    | expr SEMICOLON
    | SEMICOLON /* Permitir punto y coma extra */
;

function:
    FN IDENTIFIER LPAREN params RPAREN ARROW type LBRACE stmts RBRACE
    | FN IDENTIFIER LPAREN params RPAREN LBRACE stmts RBRACE  /* Función sin tipo de retorno */
;

declaration:
    LET opt_mut IDENTIFIER COLON type ASSIGN expr
    | LET opt_mut IDENTIFIER ASSIGN expr  /* Inferencia de tipos */
;

if_stmt:
    IF expr LBRACE stmts RBRACE opt_else
;

return_stmt:
    RETURN
    | RETURN expr
;

params:
    /* vacío */
    | param_list
;

param_list:
    param
    | param COMMA param_list
;

param:
    IDENTIFIER COLON type
;

type:
    I32
    | F64
    | BOOL
    | CHAR_TYPE
    | STR_TYPE
;

opt_else:
    /* vacío */
    | ELSE LBRACE stmts RBRACE
;

opt_mut:
    /* vacío */
    | MUT
;

expr:
    logic_expr
;

logic_expr:
    comp_expr
    | logic_expr AND comp_expr
;

comp_expr:
    arith_expr
    | arith_expr LT arith_expr
    | arith_expr GT arith_expr
    | arith_expr EQ arith_expr
    | arith_expr NEQ arith_expr
;

arith_expr:
    term
    | arith_expr PLUS term
    | arith_expr MINUS term
;

term:
    factor
    | term MUL factor
    | term DIV factor
    | term MOD factor
;

factor:
    NUMBER
    | IDENTIFIER
    | CHAR
    | STRING
    | LPAREN expr RPAREN
    | IDENTIFIER LPAREN args RPAREN  /* Llamada a función */
;

args:
    /* vacío */
    | expr_list
;

expr_list:
    expr
    | expr COMMA expr_list
;

%%

int yyerror(char *s) {
    printf("[ERROR SINTÁCTICO] %s en línea %d!!!\n", s, line);
    return 0;
}

int main() {
    printf(">>> ANÁLISIS LÉXICO Y SINTÁCTICO <<<\n");
    printf("Procesando el archivo...\n");
    int result = yyparse();
    if (result == 0) {
        printf(">>> ANÁLISIS COMPLETADO SIN ERRORES <<<\n");
    } else {
        printf(">>> ANÁLISIS COMPLETADO CON ERRORES <<<\n");
    }
    return 0;
}