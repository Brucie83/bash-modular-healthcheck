#!/bin/bash

# Modo estricto en -o pipefail

set -e
set -o pipefail

false | grep "algo"

echo "ESTO NO DEBERIA IMPRIMIRSE"

