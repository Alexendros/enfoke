#!/usr/bin/env bash
# Compara la versión LOCAL del catálogo de enfoques contra la del remoto VALIDADO (online).
# El remoto validado = rama por defecto de 'origin' (lo publicado y probado en GitHub).
# El local puede estar por delante (en obras desde Windsurf) — eso NO es error, es desarrollo.
#
# Salidas:
#   0  local == online, o no hay remoto (nada que comparar)
#   3  local POR DELANTE del online (estás trabajando una versión nueva: informativo)
#   4  local POR DETRÁS del online (tu copia está vieja: deberías hacer pull)
set -uo pipefail

DIR_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_LOCAL="$(cat "$DIR_REPO/VERSIÓN" 2>/dev/null | tr -d '[:space:]')"

cd "$DIR_REPO" || exit 0

# Sin remoto configurado → no hay "online" contra el que validar. Salir limpio.
if ! git rev-parse --git-dir >/dev/null 2>&1; then
	echo "enfoques: no es un repo git todavía (local $VERSION_LOCAL)."
	exit 0
fi
if ! git remote get-url origin >/dev/null 2>&1; then
	echo "enfoques: sin remoto 'origin'. Versión local $VERSION_LOCAL (validación online inactiva)."
	exit 0
fi

# Rama por defecto del remoto (la validada)
RAMA_DEFECTO="$(git remote show origin 2>/dev/null | awk '/HEAD branch/{print $NF}')"
RAMA_DEFECTO="${RAMA_DEFECTO:-main}"

# Trae solo el fichero VERSIÓN del remoto sin tocar el working tree
git fetch --quiet origin "$RAMA_DEFECTO" 2>/dev/null || {
	echo "enfoques: no se pudo contactar 'origin' (local $VERSION_LOCAL)."
	exit 0
}
VERSION_ONLINE="$(git show "origin/${RAMA_DEFECTO}:VERSIÓN" 2>/dev/null | tr -d '[:space:]')"

if [ -z "$VERSION_ONLINE" ]; then
	echo "enfoques: el remoto aún no publica VERSIÓN (local $VERSION_LOCAL)."
	exit 0
fi

if [ "$VERSION_LOCAL" = "$VERSION_ONLINE" ]; then
	echo "enfoques: sincronizado (v$VERSION_LOCAL)."
	exit 0
fi

# Orden semántico: la menor de las dos según sort -V
MENOR="$(printf '%s\n%s\n' "$VERSION_LOCAL" "$VERSION_ONLINE" | sort -V | head -1)"
if [ "$MENOR" = "$VERSION_ONLINE" ]; then
	echo "enfoques: LOCAL ($VERSION_LOCAL) por delante del online ($VERSION_ONLINE) — en obras."
	exit 3
else
	echo "enfoques: LOCAL ($VERSION_LOCAL) por DETRÁS del online ($VERSION_ONLINE) — haz 'git pull'."
	exit 4
fi
