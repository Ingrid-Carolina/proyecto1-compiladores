# Informe Técnico - Proyecto 1 Compiladores
## Universidad Tecnológica Centroamericana (UNITEC)
**Alumna:** Ingrid Carolina Hernandez Inestroza
**Asignatura:** Compiladores 1


## Descripción
Implementación de lexer (Flex) y parser (Bison) para subconjunto de RUST en C.

## Tokens del Lexer
| Token | Descripción |
|-------|-------------|
| FN | Palabra reservada fn |
| LET | Declaración de variable |
| MUT | Variable mutable |
| IF/ELSE | Control de flujo |
| WHILE/FOR | Bucles |
| RETURN | Retorno de función |
| I32/F64/BOOL/CHAR/STR | Tipos de datos |
| IDENTIFIER | Identificadores |
| NUMBER | Literales numéricos |

## Gramática
Ver parser.y para la gramática BNF completa.

## Pruebas
- test.rs: Funciones con parámetros y retorno
