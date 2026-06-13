#!/usr/bin/env bash
# Hook opcional de validación de versión del catálogo de enfoques.
# Diseñado para ser INERTE mientras no exista remoto: no molesta durante el desarrollo local.
#
# Para activarlo, encadénalo a un hook UserPromptSubmit/SessionStart en settings.json.
# Mientras no haya 'origin' configurado, sale en silencio (exit 0, sin salida ruidosa).
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHECK="$REPO_DIR/scripts/check-version.sh"

[ -x "$CHECK" ] || exit 0

# Solo emite algo si el local está POR DETRÁS del online (la única condición que exige acción).
# Por delante (en obras) o en sync → silencio total.
OUT="$("$CHECK" 2>/dev/null)"
RC=$?
if [ "$RC" = "4" ]; then
	# additionalContext para el agente: avisa de copia desactualizada.
	echo "⚠ Catálogo de enfoques desactualizado: $OUT"
fi
exit 0
