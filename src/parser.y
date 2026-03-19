%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int yyerror(char *s);
extern int line;
extern char *yytext;

#define MAX_BUF 8192
char tok_buf[MAX_BUF][256];
int  tok_n = 0;
char tree_buf[MAX_BUF][256];
int  tree_n = 0;

void save_token(const char *s) {
    if (tok_n < MAX_BUF) strncpy(tok_buf[tok_n++], s, 255);
}

int depth = 0;

void pnode(const char *label, const char *value) {
    char out[256];
    char pad[128] = {0};
    int i;
    for (i = 0; i < depth && i < 60; i++) strcat(pad, "  ");
    if (value && value[0])
        snprintf(out, 256, "%s%s: %s", pad, label, value);
    else
        snprintf(out, 256, "%s%s", pad, label);
    if (tree_n < MAX_BUF) strncpy(tree_buf[tree_n++], out, 255);
}
%}

%union {
    char   *n;
    double  number;
}

%token <n> IDENTIFIER STRING CHAR
%token <number> NUMBER
%token FN LET MUT IF ELSE WHILE FOR RETURN IN
%token LBRACE RBRACE LPAREN RPAREN SEMICOLON COMMA
%token ASSIGN EQ NEQ LT GT PLUS MINUS MUL DIV ARROW AND MOD
%token I32 F64 BOOL CHAR_TYPE STR_TYPE COLON
%token OTHER

%left  AND
%left  EQ NEQ
%left  LT GT
%left  PLUS MINUS
%left  MUL DIV MOD

%type <n> type opt_rettype

%%

program: stmts ;

stmts:
    /* vacio */
  | stmt stmts
;

stmt:
    function
  | declaration SEMICOLON
  | if_stmt
  | return_stmt SEMICOLON
  | expr SEMICOLON
  | SEMICOLON
;

/* ── Una sola regla de función con retorno opcional ── */
function:
    FN IDENTIFIER LPAREN
        { pnode("Function", $2); depth++;
          pnode("Params",""); depth++; }
    params RPAREN opt_rettype LBRACE
        { depth--;
          if ($7 && $7[0]) pnode("ReturnType", $7);
          pnode("Block",""); depth++;
          pnode("Statements",""); depth++; }
    stmts RBRACE
        { depth--; depth--; depth--; }
;

opt_rettype:
    /* vacio */     { $$ = ""; }
  | ARROW type      { $$ = $2; }
;

declaration:
    LET opt_mut IDENTIFIER COLON type ASSIGN
        { char b[256]; snprintf(b,256,"%s : %s",$3,$5);
          pnode("Let",b); depth++; }
    expr { depth--; }

  | LET opt_mut IDENTIFIER ASSIGN
        { pnode("Let",$3); depth++; }
    expr { depth--; }
;

if_stmt:
    IF
        { pnode("If",""); depth++;
          pnode("Condition",""); depth++; }
    expr
        { depth--;
          pnode("Then",""); depth++;
          pnode("Block",""); depth++;
          pnode("Statements",""); depth++; }
    LBRACE stmts RBRACE
        { depth--; depth--; depth--; }
    opt_else
        { depth--; }
;

return_stmt:
    RETURN           { pnode("Return",""); }
  | RETURN           { pnode("Return",""); depth++; } expr { depth--; }
;

params:
    /* vacio */
  | param_list
;
param_list:
    param
  | param COMMA param_list
;
param:
    IDENTIFIER COLON type
        { char b[256]; snprintf(b,256,"%s : %s",$1,$3); pnode("Param",b); }
;

type:
    I32       { $$ = "i32"; }
  | F64       { $$ = "f64"; }
  | BOOL      { $$ = "bool"; }
  | CHAR_TYPE { $$ = "char"; }
  | STR_TYPE  { $$ = "str"; }
;

opt_else:
    /* vacio */
  | ELSE
        { pnode("Else",""); depth++;
          pnode("Block",""); depth++;
          pnode("Statements",""); depth++; }
    LBRACE stmts RBRACE
        { depth--; depth--; depth--; }
;

opt_mut:
    /* vacio */
  | MUT
;

expr:       logic_expr ;
logic_expr: comp_expr
  | logic_expr AND comp_expr  { pnode("BinaryOp","&&"); }
;
comp_expr:  arith_expr
  | arith_expr LT  arith_expr { pnode("BinaryOp","<");  }
  | arith_expr GT  arith_expr { pnode("BinaryOp",">");  }
  | arith_expr EQ  arith_expr { pnode("BinaryOp","=="); }
  | arith_expr NEQ arith_expr { pnode("BinaryOp","!="); }
;
arith_expr: term
  | arith_expr PLUS  term     { pnode("BinaryOp","+"); }
  | arith_expr MINUS term     { pnode("BinaryOp","-"); }
;
term: factor
  | term MUL  factor { pnode("BinaryOp","*");  }
  | term DIV  factor { pnode("BinaryOp","/");  }
  | term MOD  factor { pnode("BinaryOp","%%"); }
;
factor:
    NUMBER
        { char b[64]; snprintf(b,64,"%.10g",$1); pnode("Literal(i32)",b); }
  | IDENTIFIER LPAREN
        { pnode("Call",$1); depth++; pnode("Args",""); depth++; }
    args RPAREN
        { depth--; depth--; }
  | IDENTIFIER    { pnode("Identifier",$1); }
  | CHAR          { pnode("Literal(char)",$1); }
  | STRING        { pnode("Literal(str)",$1); }
  | LPAREN expr RPAREN
;

args:
    /* vacio */
  | expr_list
;
expr_list:
    expr
  | expr COMMA expr_list
;

%%

int yyerror(char *s) {
    char b[256];
    snprintf(b,256,"[ERROR SINTACTICO] %s en linea %d", s, line);
    if (tree_n < MAX_BUF) strncpy(tree_buf[tree_n++], b, 255);
    return 0;
}

int main(int argc, char *argv[]) {
    extern FILE *yyin;
    int i, result;
    if (argc >= 2) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Error: no se pudo abrir '%s'\n", argv[1]);
            return 1;
        }
    }
    result = yyparse();
    printf("\n================================================\n");
    printf("  COMPILADOR RUST -- Proyecto 1   UNITEC\n");
    printf("  Alumna: Ingrid Carolina Hernandez Inestroza\n");
    printf("================================================\n");
    if (argc >= 2) printf("  Archivo: %s\n", argv[1]);
    printf("================================================\n\n");
    printf("-- TOKENS ---------------------------------------\n\n");
    for (i = 0; i < tok_n; i++) printf("%s\n", tok_buf[i]);
    printf("\n-- ARBOL DE DERIVACION --------------------------\n\n");
    for (i = 0; i < tree_n; i++) printf("%s\n", tree_buf[i]);
    printf("\n================================================\n");
    if (result == 0)
        printf("  ✓  ANALISIS COMPLETADO SIN ERRORES\n");
    else
        printf("  ✗  ANALISIS COMPLETADO CON ERRORES\n");
    printf("================================================\n\n");
    if (argc >= 2 && yyin) fclose(yyin);
    return result;
}
