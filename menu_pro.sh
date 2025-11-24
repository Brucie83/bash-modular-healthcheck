#!/bin/bash

# Colores ANSI
verde="\e[32m"
rojo="\e[31m"
amarillo="\e[33m"
reset="\e[0m"

mostrar_fecha() {
    echo -e "${verde}Fecha actual:${reset}"
    date
    echo ""
}

mostrar_disco() {
    echo -e "${verde}Uso de disco:${reset}"
    df -h /
    echo ""
}

mostrar_procesos() {
    echo -e "${verde}Procesos activos:${reset}"
    ps aux | head -n 10
    echo ""
}

while true; do
    clear
    echo -e "${amarillo}=== Menu Profesional DevOps ===${reset}"
    echo "1) Mostrar fecha"
    echo "2) Mostrar uso de disco"
    echo "3) Mostrar procesos"
    echo "4) Salir"
    echo ""

    read -p "Elige una opcion: " opcion

    case $opcion in
        1) mostrar_fecha
           read -p "Presiona ENTER para continuar..."
           ;;
        2) mostrar_disco 
           read -p "Presiona ENTER para continuar..."
           ;;
        3) mostrar_procesos
           read -p "Presiona ENTER para continuar..."
           ;;
        4)
            echo -e "${rojo}Saliendo...${reset}"
            exit 0
            ;;
        *)
            echo -e "${rojo}Opcion no calida. Intente de nuevo.${reset}"
            sleep 1
            ;;
    esac
done
