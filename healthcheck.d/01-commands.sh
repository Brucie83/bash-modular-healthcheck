#!/bin/bash
# Modulo: comandos
# Este modulo contiene SOLAMENTE los checks relacionados con comandos del sistema

COMMANDS_LIST=( bash curl docker )

run_commands_checks() {
   [[ "$CHECK_COMMANDS" == true ]] || return 0

    for cmd in "${COMMANDS_LIST[@]}"; do
        if check_command "$cmd"; then
            ((COMMANDS_OK++)) || true
        else
            ((COMMANDS_FAIL++)) || true
        fi
    done
}
