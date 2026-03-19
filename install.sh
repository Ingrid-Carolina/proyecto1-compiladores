GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

echo ""
echo -e "${CYAN}================================================${RESET}"
echo -e "${CYAN}  Instalando dependencias del proyecto...${RESET}"
echo -e "${CYAN}================================================${RESET}"
echo ""

# Verificar que estamos en Ubuntu/Debian
if ! command -v apt-get &> /dev/null; then
    echo -e "${RED}ERROR: Este script requiere Ubuntu/Debian (apt-get)${RESET}"
    exit 1
fi

echo -e "${YELLOW}Actualizando lista de paquetes...${RESET}"
sudo apt-get update -qq

echo -e "${YELLOW}Instalando flex, bison, gcc...${RESET}"
sudo apt-get install -y flex bison gcc make

echo ""
echo -e "${GREEN}✓ Dependencias instaladas correctamente${RESET}"
echo ""
echo -e "${CYAN}Ahora puedes ejecutar:${RESET}"
echo -e "  ${GREEN}make${RESET}              → Compilar"
echo -e "  ${GREEN}make run${RESET}          → Ejecutar con tests/test.rs"
echo -e "  ${GREEN}make run FILE=tests/test1.rs${RESET} → Ejecutar con test1.rs"
echo -e "  ${GREEN}make gui${RESET}          → Abrir interfaz gráfica"
echo ""
