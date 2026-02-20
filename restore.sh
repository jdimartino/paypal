#!/bin/bash
# restore.sh — Restaurar PayPal a una versión anterior
set -euo pipefail

PROJECT="paypal"
echo "========================================================"
echo "🔄 RESTAURACIÓN: $PROJECT"
echo "========================================================"

echo ""
echo "📜 Últimos 15 commits:"
git log -n 15 --oneline --decorate
echo ""

TAGS=$(git tag -l "pre_${PROJECT}_*" --sort=-version:refname 2>/dev/null | head -5)
if [ -n "$TAGS" ]; then
  echo "🏷️  Tags de respaldo (PushGlobal):"
  while IFS= read -r tag; do
    echo "   $tag"
  done <<< "$TAGS"
  echo ""
fi

if [ -d "history" ] && [ "$(ls -A history/ 2>/dev/null)" ]; then
  echo "📁 Copias en history/:"
  ls -1h history/ | tail -5
  echo ""
fi

echo "Introduce el ID del commit o tag al que quieres volver:"
read -r RESTORE_POINT

if [ -z "$RESTORE_POINT" ]; then
  echo "❌ Operación cancelada."
  exit 1
fi

if ! git rev-parse --verify "$RESTORE_POINT" > /dev/null 2>&1; then
  echo "❌ '$RESTORE_POINT' no es un commit o tag válido."
  exit 1
fi

echo ""
echo "⚠️  Vas a restaurar $PROJECT a: $RESTORE_POINT"
echo "¿Confirmar? (s/N):"
read -r CONFIRM
if [[ ! "$CONFIRM" =~ ^[sS]$ ]]; then
  echo "❌ Cancelado."
  exit 0
fi

TS=$(date +%Y%m%d_%H%M%S)
git add -A
git stash push -m "pre-restore_${TS}" 2>/dev/null || true

git checkout "$RESTORE_POINT" -- .

echo ""
echo "========================================================"
echo "🎉 ¡$PROJECT restaurado a: $RESTORE_POINT!"
echo "   → Deshacer: git stash pop"
echo "   → Confirmar: PushGlobal"
echo "========================================================"
