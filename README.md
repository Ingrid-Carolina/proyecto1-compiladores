# Proyecto 1 - Compiladores 1
Lexer y Parser para subconjunto de RUST usando Flex y Bison en C.
Alumna: Ingrid Carolina Hernández Inestroza — 12141186  
Docente: Ing. Roman Pineda | Sección: 467
---

## Estructura del Proyecto

```
proyecto_compiladores/
├── Makefile              ← Sistema de compilación
├── install.sh            ← Instala dependencias (Ubuntu)
├── run.sh                ← Script rápido de ejecución
├── README.md
│
├── src/
│   ├── lexer.l           ← Analizador léxico (Flex)
│   └── parser.y          ← Analizador sintáctico (Bison) + árbol
│
├── gui/
│   └── compilador_rust.html  ← Interfaz gráfica (abrir en navegador)
│
├── tests/
│   ├── test.rs           ← Prueba completa
│   ├── test1.rs          ← Prueba básica (del enunciado)
│   └── test2.rs          ← Prueba con recursión
│
└── build/                ← Archivos generados (auto-creado por make)
    ├── compiler          ← Binario final
    ├── parser.tab.c
    ├── parser.tab.h
    └── lex.yy.c
```

---

## Instalación rápida (Ubuntu)

```bash
# 1. Instalar dependencias
./install.sh

# 2. Compilar el proyecto
make

# 3. Ejecutar
make run                          # usa tests/test.rs
make run FILE=tests/test1.rs      # archivo específico
./build/compiler tests/test1.rs   # equivalente directo
```

---

## Interfaz Gráfica

```bash
make gui
```

Abre `gui/compilador_rust.html` en el navegador.  
También puedes abrirlo manualmente haciendo doble clic en el archivo.

La GUI permite:
- Escribir código RUST directamente en el editor
- Cargar archivos `.rs` desde tu computadora
- Ver el árbol de derivación en formato texto (igual que la terminal)
- Ver la consola de salida completa

---

## Comandos Make

| Comando | Descripción |
|---------|-------------|
| `make` | Compilar todo el proyecto |
| `make run` | Ejecutar con `tests/test.rs` |
| `make run FILE=x.rs` | Ejecutar con archivo específico |
| `make test` | Ejecutar todos los archivos en `tests/` |
| `make gui` | Abrir interfaz gráfica |
| `make clean` | Limpiar archivos generados |

---

## Ejemplo de salida

```
================================================
  COMPILADOR RUST — Proyecto 1   UNITEC
================================================
  Archivo: tests/test1.rs
================================================

── TOKENS ──────────────────────────────────────

[TOKEN] FN          (linea 1)
[TOKEN] IDENTIFIER  (linea 1): suma
...

── ARBOL DE DERIVACION ─────────────────────────

Function: suma
  Params:
    Param: a : i32
    Param: b : i32
  ReturnType: i32
  Block:
    Statements:
      Return
        BinaryOp: +
          Identifier: a
          Identifier: b
Function: main
  Params:
  Block:
    Statements:
      Let: x : i32
        Literal(i32): 10
      Let: y : i32
        Literal(i32): 20
      If
        Condition:
          BinaryOp: <
            Identifier: x
            Identifier: y
        Then:
          Block:
            Statements:
              Let: resultado
                Call: suma
                  Args:
                    Identifier: x
                    Identifier: y
        Else:
          Block:
            Statements:
              Return

================================================
  ✓  ANALISIS COMPLETADO SIN ERRORES
================================================
```
