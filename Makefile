#CC = g++
#CFLAGS = -std=c++11 -Wall -I. -Wno-register

#default:
    #@clear
   # flex -l lexer.l
  #  bison -dv parser.y
 #   gcc -o main parser.tab.c lex.yy.c -lfl

#clean:
    #rm -f main parser.tab.c parser.tab.h parser.output lex.yy.c


    
CC     = gcc
FLEX   = flex
BISON  = bison

SRC   = src
BUILD = build
GUI   = gui
TESTS = tests

BIN = $(BUILD)/compiler

GREEN  = \033[1;32m
CYAN   = \033[1;36m
YELLOW = \033[1;33m
RED    = \033[1;31m
RESET  = \033[0m

.PHONY: all clean run test gui help check-deps

all: check-deps $(BIN)
	@echo ""
	@echo "$(GREEN)✓ Compilacion exitosa — binario: $(BIN)$(RESET)"
	@echo "$(CYAN)  Uso:  make run$(RESET)"
	@echo "$(CYAN)  GUI:  make gui$(RESET)"
	@echo ""

# ── Verificar dependencias ────────────────────────────────────────────
check-deps:
	@echo "$(YELLOW)Verificando dependencias...$(RESET)"
	@which flex  > /dev/null 2>&1 || \
	  (echo "$(RED)flex no encontrado. Ejecuta: sudo apt install flex$(RESET)" && exit 1)
	@which bison > /dev/null 2>&1 || \
	  (echo "$(RED)bison no encontrado. Ejecuta: sudo apt install bison$(RESET)" && exit 1)
	@which gcc   > /dev/null 2>&1 || \
	  (echo "$(RED)gcc no encontrado. Ejecuta: sudo apt install gcc$(RESET)" && exit 1)
	@echo "$(GREEN)  ✓ flex, bison, gcc$(RESET)"

# ── Crear carpeta build ───────────────────────────────────────────────
$(BUILD):
	@mkdir -p $(BUILD)

# ── Bison: parser.y → build/parser.tab.c + build/parser.tab.h ────────
$(BUILD)/parser.tab.c $(BUILD)/parser.tab.h: $(SRC)/parser.y | $(BUILD)
	@echo "$(CYAN)  [BISON] Generando parser...$(RESET)"
	$(BISON) -d -o $(BUILD)/parser.tab.c $(SRC)/parser.y

# ── Flex: lexer.l → build/lex.yy.c  (necesita el .h de bison) ────────
$(BUILD)/lex.yy.c: $(SRC)/lexer.l $(BUILD)/parser.tab.h | $(BUILD)
	@echo "$(CYAN)  [FLEX]  Generando lexer...$(RESET)"
	$(FLEX) -o $(BUILD)/lex.yy.c $(SRC)/lexer.l

# ── GCC: compilar binario final ───────────────────────────────────────
$(BIN): $(BUILD)/parser.tab.c $(BUILD)/lex.yy.c | $(BUILD)
	@echo "$(CYAN)  [GCC]   Compilando binario...$(RESET)"
	$(CC) -o $(BIN) \
	    $(BUILD)/parser.tab.c \
	    $(BUILD)/lex.yy.c \
	    -I$(BUILD) \
	    -lfl -lm
	@chmod +x $(BIN)

# ── Ejecutar ──────────────────────────────────────────────────────────
FILE ?= tests/test.rs
run: all
	@echo ""
	@echo "$(YELLOW)========================================$(RESET)"
	@echo "$(YELLOW)  Analizando: $(FILE)$(RESET)"
	@echo "$(YELLOW)========================================$(RESET)"
	@test -f "$(FILE)" || \
	  (echo "$(RED)Archivo '$(FILE)' no encontrado$(RESET)"; exit 1)
	@$(BIN) $(FILE)

# ── Ejecutar todos los tests ──────────────────────────────────────────
test: all
	@for f in $(TESTS)/*.rs; do \
	    echo ""; \
	    echo "$(CYAN)━━━ $$f ━━━$(RESET)"; \
	    $(BIN) $$f; \
	done

# ── Abrir GUI en el navegador ─────────────────────────────────────────
gui:
	@test -f $(GUI)/compilador_rust.html || \
	  (echo "$(RED)GUI no encontrada: $(GUI)/compilador_rust.html$(RESET)" && exit 1)
	@echo "$(GREEN)Abriendo interfaz grafica...$(RESET)"
	@xdg-open $(GUI)/compilador_rust.html 2>/dev/null || \
	 google-chrome --new-tab $(GUI)/compilador_rust.html 2>/dev/null || \
	 firefox $(GUI)/compilador_rust.html 2>/dev/null || \
	 (echo "$(CYAN)Abrir manualmente: $(PWD)/$(GUI)/compilador_rust.html$(RESET)")

# ── Limpiar ───────────────────────────────────────────────────────────
clean:
	@rm -rf $(BUILD)
	@echo "$(GREEN)✓ Limpiado$(RESET)"

# ── Ayuda ─────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "$(CYAN)╔═══════════════════════════════════════╗$(RESET)"
	@echo "$(CYAN)║  Compilador RUST — UNITEC Proyecto 1  ║$(RESET)"
	@echo "$(CYAN)╚═══════════════════════════════════════╝$(RESET)"
	@echo ""
	@echo "  $(GREEN)make$(RESET)                  Compilar"
	@echo "  $(GREEN)make run$(RESET)              Ejecutar con tests/test.rs"
	@echo "  $(GREEN)make run FILE=x.rs$(RESET)    Ejecutar con archivo x.rs"
	@echo "  $(GREEN)make test$(RESET)             Ejecutar todos los tests/"
	@echo "  $(GREEN)make gui$(RESET)              Abrir interfaz grafica"
	@echo "  $(GREEN)make clean$(RESET)            Limpiar archivos generados"
	@echo ""
