#!/bin/bash

# Modo estricto en -u para fallar si una variable no esta definida

set -u

echo "El valor es: $VARIABLE_QUE_NO_EXISTE"
