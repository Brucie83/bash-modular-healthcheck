#!/bin/bash
# Modulo: discos
# Este modulo SOLAMENTE verifica que los discos esten disponibles

DISKS_LIST=( / /root /etc /var )

run_disks_checks() {
   [[ "$CHECK_DISKS" == true ]] || return 0

   for disk in "${DISKS_LIST[@]}"; do
        if check_disk "$disk"; then
            ((DISKS_OK++)) || true
        else
            ((DISKS_FAIL++)) || true
        fi
    done
}
