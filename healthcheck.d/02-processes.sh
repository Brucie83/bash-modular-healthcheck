#!/bin/bash

# Modulo: procesos
# Este modulo SOLAMENTE hace revision de los procesos del sistema

PROCESSES_LIST=( cron dockerd )

run_processes_checks() {
    [[ "$CHECK_PROCESSES" == true ]] || return 0

    for proc in "${PROCESSES_LIST[@]}"; do
        if check_process "$proc"; then
            ((PROCESSES_OK++)) || true
        else
            ((PROCESSES_FAIL++)) || true
        fi
    done
} 

