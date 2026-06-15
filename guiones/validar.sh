#!/usr/bin/env bash
# Valida la integridad del catálogo de Enfoques: formato de VERSIÓN, presencia y
# frontmatter de las definiciones, referencias cruzadas con LÉEME.md y ausencia de
# rutas rotas conocidas. Sin dependencias externas (solo bash + coreutils).
#
# Salida:
#   0  todo correcto
#   1  alguna comprobación falló (detalle en stderr)
set -euo pipefail

DIR_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR_REPO"

ERRORES=0
fallo() { printf 'FALLO: %s\n' "$1" >&2; ERRORES=$((ERRORES + 1)); }
ok()    { printf 'OK: %s\n' "$1"; }

# Enfoques esperados en el catálogo (fuente de verdad de la lista).
ENFOQUES_ESPERADOS=(conciso rustir experto desarrollador automatizado pruebas entrega)

# 1) VERSIÓN existe y sigue versionado semántico MAJOR.MINOR.PATCH.
if [ ! -f VERSIÓN ]; then
	fallo "no existe el fichero VERSIÓN"
else
	VERSION="$(tr -d '[:space:]' < VERSIÓN)"
	if printf '%s' "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
		ok "VERSIÓN con formato semántico ($VERSION)"
	else
		fallo "VERSIÓN no sigue MAJOR.MINOR.PATCH (valor: '$VERSION')"
	fi
fi

# 2) Existen exactamente los ficheros de definición esperados.
for palabra in "${ENFOQUES_ESPERADOS[@]}"; do
	if [ -f "definiciones/$palabra.md" ]; then
		ok "definición presente: $palabra"
	else
		fallo "falta definiciones/$palabra.md"
	fi
done

# Avisa de definiciones no catalogadas (fichero suelto sin entrada esperada).
for f in definiciones/*.md; do
	[ -e "$f" ] || continue
	base="$(basename "$f" .md)"
	encontrado=0
	for palabra in "${ENFOQUES_ESPERADOS[@]}"; do
		[ "$base" = "$palabra" ] && encontrado=1 && break
	done
	[ "$encontrado" -eq 1 ] || fallo "definición no catalogada: definiciones/$base.md"
done

# 3) Cada definición: nombre saneado, frontmatter y secciones mínimas.
for palabra in "${ENFOQUES_ESPERADOS[@]}"; do
	f="definiciones/$palabra.md"
	[ -f "$f" ] || continue

	# Saneamiento: el nombre que el motor usa para componer rutas debe ser seguro.
	if ! printf '%s' "$palabra" | grep -Eq '^[a-z0-9-]+$'; then
		fallo "nombre de Enfoque con caracteres no permitidos: '$palabra'"
	fi

	# Frontmatter delimitado por '---' en la primera línea.
	if [ "$(head -n1 "$f")" != "---" ]; then
		fallo "$f: no empieza con frontmatter '---'"
		continue
	fi
	frontmatter="$(awk 'NR>1{if($0=="---")exit; print}' "$f")"
	for clave in name description keep-coding-instructions; do
		if ! printf '%s\n' "$frontmatter" | grep -Eq "^$clave:"; then
			fallo "$f: falta la clave de frontmatter '$clave'"
		fi
	done

	# Cuerpo: al menos un H1 y la línea roja común "Lo que NO se sacrifica".
	grep -Eq '^# ' "$f"                  || fallo "$f: sin encabezado H1"
	grep -Eq 'Lo que NO se sacrifica' "$f" || fallo "$f: falta la sección 'Lo que NO se sacrifica'"
done

# 4) Referencia cruzada: cada Enfoque aparece citado en LÉEME.md.
if [ -f LÉEME.md ]; then
	for palabra in "${ENFOQUES_ESPERADOS[@]}"; do
		grep -q "\`$palabra\`" LÉEME.md || fallo "LÉEME.md no menciona el Enfoque '$palabra'"
	done
	ok "referencias cruzadas LÉEME.md ↔ definiciones"
else
	fallo "no existe LÉEME.md"
fi

# 5) Directorios citados en la estructura del repo existen.
for dir in definiciones documentacion guiones enganches; do
	[ -d "$dir" ] || fallo "directorio ausente citado en la estructura: $dir/"
done

# 6) Sin rutas rotas conocidas (regresión documental).
if grep -rqn 'complementos/enfoques' --include='*.md' .; then
	fallo "reaparece la ruta rota 'complementos/enfoques' en la documentación"
fi

if [ "$ERRORES" -eq 0 ]; then
	printf '\nValidación correcta: catálogo íntegro.\n'
	exit 0
else
	printf '\nValidación con %d fallo(s).\n' "$ERRORES" >&2
	exit 1
fi
