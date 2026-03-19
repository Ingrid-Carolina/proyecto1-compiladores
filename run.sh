
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

FILE="${1:-tests/test.rs}"

echo ""
echo -e "${CYAN}════════════════════════════════════════${RESET}"
echo -e "${CYAN}  Compilando el proyecto...${RESET}"
echo -e "${CYAN}════════════════════════════════════════${RESET}"

make all 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}Error en la compilación del proyecto${RESET}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Ejecutando: ${FILE}${RESET}"
echo ""

./build/compiler "$FILE"
