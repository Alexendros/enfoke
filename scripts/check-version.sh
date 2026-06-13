#!/usr/bin/env bash
# Compara la versión LOCAL del catálogo de enfoques contra la del remoto VALIDADO (online).
# El remoto validado = rama por defecto de 'origin' (lo que está publicado y probado).
# El local puede estar por delante (en obras) — eso NO es error, es desarrollo.
#
# Salidas:
#   0  local == online, o no hay remoto (nada que comparar)
#   3  local POR DELANTE del online (estás trabajando una versión nueva: informativo)
#   4  local POR DETRÁS del online (tu copia está vieja: deberías hacer pull)
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_VERSION="$(cat "$REPO_DIR/VERSION" 2>/dev/null | tr -d '[:space:]')"

cd "$REPO_DIR" || exit 0

# Sin remoto configurado → no hay "online" contra el que validar. Salir limpio.
if ! git rev-parse --git-dir >/dev/null 2>&1; then
	echo "enfoques: no es un repo git todavía (local $LOCAL_VERSION)."
	exit 0
fi
if ! git remote get-url origin >/dev/null 2>&1; then
	echo "enfoques: sin remoto 'origin'. Versión local $LOCAL_VERSION (validación online inactiva)."
	exit 0
fi

# Rama por defecto del remoto (la validada)
DEFAULT_BRANCH="$(git remote show origin 2>/dev/null | awk '/HEAD branch/{print $NF}')"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"

# Trae solo el fichero VERSION del remoto sin tocar el working tree
git fetch --quiet origin "$DEFAULT_BRANCH" 2>/dev/null || {
	echo "enfoques: no se pudo contactar 'origin' (local $LOCAL_VERSION)."
	exit 0
}
ONLINE_VERSION="$(git show "origin/${DEFAULT_BRANCH}:VERSION" 2>/dev/null | tr -d '[:space:]')"

if [ -z "$ONLINE_VERSION" ]; then
	echo "enfoques: el remoto aún no publica VERSION (local $LOCAL_VERSION)."
	exit 0
fi

if [ "$LOCAL_VERSION" = "$ONLINE_VERSION" ]; then
	echo "enfoques: en sync (v$LOCAL_VERSION)."
	exit 0
fi

# Orden semántico: la menor de las dos según sort -V
LOWER="$(printf '%s\n%s\n' "$LOCAL_VERSION" "$ONLINE_VERSION" | sort -V | head -1)"
if [ "$LOWER" = "$ONLINE_VERSION" ]; then
	echo "enfoques: LOCAL ($LOCAL_VERSION) por delante del online ($ONLINE_VERSION) — en obras."
	exit 3
else
	echo "enfoques: LOCAL ($LOCAL_VERSION) por DETRÁS del online ($ONLINE_VERSION) — haz 'git pull'."
	exit 4
fi
