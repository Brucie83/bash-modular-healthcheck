#!/bin/bash
#==========================
# DevOps Healthcheck Script
#==========================

#Inicializacion de variables
COMMANDS_OK=0
COMMANDS_FAIL=0
PROCESSES_OK=0
PROCESSES_FAIL=0
PORTS_OK=0
PORTS_FAIL=0
DISKS_OK=0
DISKS_FAIL=0
GLOBAL_FAILURES=0
GLOBAL_STATUS=0

#Modo estricto para evitar errores silenciosos
set -euo pipefail

# Motor de carga de los modulos
MODULES_DIR="./healthcheck.d"
for file in "$MODULES_DIR"/*.sh; do
    source "$file"
done

# Modo debug (por defecto apagado)

DEBUG=false

# Si el primer argumento es --debug, activar la variable DEBUG

if [[ "${1:-}" == "--debug" ]]; then
    DEBUG=true
    # Quitamos el argumento para que el resto del script no lo vea
    shift
fi

# Activar debug si el user lo pide

if [[ "$DEBUG" == true ]]; then
    set -x
fi

# Variables globales
mkdir -p "$HOME/healthcheck_logs"
LOG_DIR="$HOME/healthcheck_logs"
LOG_FILE="$LOG_DIR/healthcheck_$(date +%Y%m%d_%H%M%S).log"

# Funciones

log_msg() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

print_status() {
    local level="$1"
    local message="$2"

    #Colores
    local GREEN="\e[32m"
    local RED="\e[31m"
    local YELLOW="\e[33m"
    local RESET="\e[0m"

    case "$level" in 
        OK)
            echo -e "[${GREEN}OK${RESET}] $message"
            ;;
        FAIL)
            echo -e "[${RED}FAIL${RESET}] $message"
            ;;
        WARN)
            echo -e "[${YELLOW}WARN${RESET}] $message"
            ;;
        *)
            echo "[INFO] $message"
            ;;
    esac
}


check_command() {
    local cmd="${1:-}"

    if [[ -z "$cmd" ]]; then
        print_status "FAIL" "check_command llamado sin argumento"
        log_msg "FAIL" "check_command sin parametro"
        return 1 # FAIL
    fi


    if command -v -- "$cmd" >/dev/null 2>&1; then
        print_status "OK" "El comando '$cmd' esta disponible"
        log_msg "OK" "Comando '$cmd' encontrado"
        return 0 # OK
    else
        print_status "FAIL" "El comando '$cmd' NO esta disponible"
        log_msg "FAIL" "Comando '$cmd' NO encontrado"
        return 1 # FAIL
    fi
}

check_process() {
    local proc="${1:-}"

    if [[ -z "$proc" ]]; then
        print_status "FAIL" "check_process llamado sin argumento"
        log_msg "FAIL" "check_process sin parametro"
        return 1 # FAIL
    fi

    if pgrep -x --  "$proc" >/dev/null 2>&1; then
        print_status "OK" "El proceso '$proc' esta corriendo"
        log_msg "OK" "Proceso '$proc' en ejecucion"
        return 0 # OK
    else
        print_status "FAIL" "El proceso '$proc' NO esta corriendo"
        log_msg "FAIL" "Proceso '$proc' NO se esta ejecutando"
        return 1 # FAIL
    fi
}

check_port() {
    local port="${1:-}"
    if [[ -z "$port" ]]; then
        print_status "FAIL" "check_port llamado sin argumento"
        log_msg "FAIL" "check_port sin parametro"
        return 1 # FAIL
    fi

    if nc -z localhost --  "$port" >/dev/null 2>&1; then
        print_status "OK" "El puerto $port esta abierto"
        log_msg "OK" "Puerto $port abierto"
        return 0 # OK
    else
        print_status "FAIL" "El puerto $port NO esta abierto"
        log_msg "FAIL" "Puerto $port cerrado"
        return 1 # FAIL
    fi
}

check_disk() {
    local disk="${1:-}"
    if [[ -z "$disk" ]]; then
        print_status "FAIL" "check_disk llamado sin argumento"
        log_msg "FAIL" "check_disk sin parametro"
        return 1 # FAIL
    fi

    if mountpoint -q --  "$disk"; then
        print_status "OK" "Disco '$disk' encontrado y disponible"
        log_msg "OK" "Disco '$disk' ok"
        return 0 # OK
    else
        print_status "FAIL" "Disco '$disk' no encontrado"
        log_msg "FAIL" "Disco '$disk' no disponible"
        return 1 # FAIL
    fi
}

show_summary() {
    echo
    echo "==========================="
    echo "     RESUMEN FINAL         "
    echo "==========================="
    echo
    echo "Comandos revisados:"
    echo "  OK:  $COMMANDS_OK"
    echo "  FAIL: $COMMANDS_FAIL"
    echo
    echo "Procesos revisados:"
    echo "  OK: $PROCESSES_OK"
    echo "  FAIL: $PROCESSES_FAIL"
    echo
    echo "Puertos revisados"
    echo "  OK: $PORTS_OK"
    echo "  FAIL: $PORTS_FAIL"
    echo
    echo "Discos revisados"
    echo " OK: $DISKS_OK"
    echo " FAIL: $DISKS_FAIL"
    echo
    echo "Estado global:"

    if ((GLOBAL_STATUS == 0 )); then
        echo "  OK"
    else
        echo "  FAIL"
    fi

    echo
    echo "Log generado en:"
    echo "  $LOG_FILE"
    echo "==========================="
}

main() {
    echo
    log_msg "INFO" "Healthcheck iniciado"
    echo
    echo "==== Iniciando todos los checks===="
    for func in $(compgen -A function); do
        case "$func" in
            run_*)
                "$func"
                ;;
        esac
    done
    show_summary
    for var in $(compgen -A variable); do
        case "$var" in
            *_FAIL)
                eval "value=\${$var}"
                if [[ -n $value && $value =~ ^[0-9]+$ ]]; then
                    GLOBAL_FAILURES=$((GLOBAL_FAILURES + value))
                fi
                ;;
        esac
    done
    if [[ $GLOBAL_FAILURES -gt 0 ]]; then
        GLOBAL_STATUS=1
        print_status "FAIL" "Terminando con $GLOBAL_FAILURES fallos en total"
        log_msg "FAIL" "$GLOBAL_FAILURES fallos en la validacion"
        return 1 # FAIL
    else
        GLOBAL_STATUS=0
        print_status "OK" "Todos los checks terminaron exitosamente"
        log_msg "OK" "Validaciones exitosas"
        return 0 # OK
    fi

}

# Punto de entrada
main "$@"
exit $?
