#!/bin/bash

#Modo estricto en -e para fallar cuando un comando falle
set -e

echo "A"
echo "B"
ls /noexiste
echo "C"
