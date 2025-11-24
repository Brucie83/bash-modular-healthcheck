#!/bin/bash
echo "=== Menu de utilidades DevOps ==="
echo ""

echo "1) Mostrar fecha actual"
echo "2) Mostrar uso de disco"
echo "3) Mostrar procesos activos"
echo "4) Salir"
echo ""

read -p "Elige una opcion: " opcion

case $opcion in
    1)
        echo "La fecha actual es>"
        date
        ;;
    2)
        echo "Uso del disco:"
        df -h /
        ;;
    3)
        echo "Procesos activos:"
        ps aux | head -n 10
        ;;
    4)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo "Opcion no valida."
        ;;
esac
