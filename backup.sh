#!/bin/bash
# Script de respaldo rápido para PayPal Auditor
git add -A
echo "Version 1.1 Con Abonos"
read message
git commit -m "$message"
git push origin main
echo "¡Respaldo completado en GitHub!"
