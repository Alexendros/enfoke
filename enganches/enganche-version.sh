#!/usr/bin/env bash
# Enganche opcional de validación de versión del catálogo de enfoques.
# Diseñado para ser INERTE mientras no exista remoto: no molesta durante el desarrollo local.
#
# Para activarlo, encadénalo a un hook UserPromptSubmit/SessionStart en settings.json.
# Mientras no haya 'origin' configurado, sale en silencio (exit 0, sin salida ruidosa).
set -uo pipefail

DIR_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPROBADOR="$DIR_REPO/guiones/comprobar-version.sh"

[ -x "$COMPROBADOR" ] || exit 0

# Solo emite algo si el local está POR DETRÁS del online (la única condición que exige acción).
# Por delante (en obras) o sincronizado → silencio total.
SALIDA="$("$COMPROBADOR" 2>/dev/null)"
CODIGO=$?
if [ "$CODIGO" = "4" ]; then
	# additionalContext para el agente: avisa de copia desactualizada.
	echo "⚠ Catálogo de enfoques desactualizado: $SALIDA"
fi
exit 0
