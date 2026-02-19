#!/bin/bash
# Script de respaldo rápido para PayPal Auditor
git add -A
echo "Introduce un breve mensaje para este respaldo:"
read message
git commit -m "$message"
git push origin main
echo "¡Respaldo completado en GitHub!"
