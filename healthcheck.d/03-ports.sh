#!/bin/bash

# Modulo: puertos

# Este modulo SOLAMENTE verifica si los puertos estan abiertos

PORTS_LIST=( 22 80 443 )

run_ports_checks() {
    for port in "${PORTS_LIST[@]}"; do
        if check_port "$port"; then
            ((PORTS_OK++)) || true
        else
            ((PORTS_FAIL++)) || true
        fi
    done
}
