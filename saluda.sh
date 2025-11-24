#!/bin/bash
echo "=== Script de saludo avanzado ==="
if [ -z "$1" ]; then
    echo "Uso: ./saluda.sh <nombre>"
    exit 1
fi

nombre="$1"

echo "Hola, $nombre!"
echo "La fecha actual es: $(date)"
echo "Script finalizado."

