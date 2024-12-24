function print_ascii_art {
cat << "EOF"
 
 GeoIP
			daniel.torres@owasp.org			

EOF
}


print_ascii_art

RED="\033[01;31m"      # Issues/Errors
GREEN="\033[01;32m"    # Success
YELLOW="\033[01;33m"   # Warnings/Information
BLUE="\033[01;34m"     # Heading
BOLD="\033[01;01m"     # Highlight
RESET="\033[00m"       # Normal


echo -e "${RED}[+]${BLUE} Copiando ejecutables ${RESET}"

sudo cp geoip-client /usr/bin/
