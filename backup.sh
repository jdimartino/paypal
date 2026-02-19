#!/bin/bash
# Script de respaldo mejorado para PayPal Auditor

# 1. Generar marca de tiempo para el archivo de respaldo
TS=$(date +%Y%m%d_%H%M%S)

echo "------------------------------------------"
echo "🔍 PREPARANDO RESPALDO DE SEGURIDAD..."
echo "------------------------------------------"

# 2. Crear copia física de segurida de la versión actual (antes del cambio)
mkdir -p history
if [ -f "public/index.html" ]; then
    cp public/index.html "history/index_$TS.html"
    echo "✅ Versión previa guardada: history/index_$TS.html"
fi

# 3. Marcar el punto exacto en Git antes de los nuevos cambios
git add -A
git tag -a "pre_$TS" -m "Respaldo automático: $TS"
echo "✅ Etiqueta de seguridad creada: pre_$TS"

# 4. Solicitar mensaje para los NUEVOS cambios
echo "------------------------------------------"
echo "Introduce el mensaje para la NUEVA versión:"
# Sugerencia por defecto basada en lo que el usuario tenía
echo "(Sugerencia: Version 1.1 Con Abonos)"
read message

# Si no escribe nada, usar un mensaje por defecto
if [ -z "$message" ]; then
  message="Actualización PayPal - $TS"
fi

# 5. Subir todo a GitHub (incluyendo las etiquetas)
git commit -m "$message"
git push origin main --tags

echo "------------------------------------------"
echo "🚀 ¡PROCESO COMPLETADO!"
echo "1. Versión vieja respaldada en /history"
echo "2. Versión nueva subida a GitHub"
echo "------------------------------------------"
