#!/bin/bash

# ===========================
#  MONITOREO AVANZADO v2
# ===========================

# Validación: si el usuario no es root, advertir
if [ "$(id -u)" -ne 0 ]; then
  echo "⚠️  Advertencia: No estás ejecutando esto como root."
  echo "Algunos datos pueden no aparecer."
fi

# Validación de parámetros
if [ "$1" == "--help" ]; then
  echo "Uso: ./monitoreo_v2.sh [opciones]"
  echo "Opciones:"
  echo "   --cpu       Mostrar procesos más pesados"
  echo "   --mem       Mostrar procesos por RAM"
  echo "   --disk      Mostrar uso del disco"
  echo "   --full      Mostrar TODO"
  exit 0
fi

# Función: procesos top por CPU
mostrar_cpu() {
  echo ""
  echo "🔥 PROCESOS CON MAYOR CPU 🔥"
  ps aux --sort=-%cpu | head -n 10
}

# Función: procesos por memoria
mostrar_mem() {
  echo ""
  echo "💾 PROCESOS POR USO DE MEMORIA 💾"
  ps aux --sort=-%mem | head -n 10
}

# Función: disco
mostrar_disk() {
  echo ""
  echo "🗂️ USO DE DISCO 🗂️"
  df -h /
}

# Ejecucion segun parametro
case "$1" in
  --cpu)  mostrar_cpu ;;
  --mem)  mostrar_mem ;;
  --disk) mostrar_disk ;;
  --full)
    mostrar_cpu
    mostrar_mem
    mostrar_disk
    ;;
  *)
    echo "❗ No diste una opción válida. Usa --help"
    ;;
esac
