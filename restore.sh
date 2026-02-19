#!/bin/bash
# Script de restauración para PayPal Auditor
git log -n 10 --oneline
echo ""
echo "Copiá y pegá el ID del backup al que querés volver (el código de 7 letras/números de la izquierda):"
read commit_id
git checkout $commit_id .
echo "¡Proyecto restaurado a la versión $commit_id!"
