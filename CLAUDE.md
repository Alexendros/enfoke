# CLAUDE.md — enfoke

<proyecto>
**Enfoques**: catálogo de "actitudes" operativas conmutables en caliente para agentes IA (Claude Code y compatibles). Un Enfoque reconfigura *cómo* razona/decide/entrega el agente (rol, principio núcleo, reglas, formato, líneas rojas), sin cambiar *qué* sabe. Eje ortogonal a la verbosidad (la verbosidad NO vive aquí).
- Repo **autocontenido**: clonarlo da el contexto completo; las definiciones reales están en `definiciones/*.md`, no son enlaces externos.
- El motor/harness vive en `~/.claude/` (NO en este repo) y lee las definiciones directamente desde donde se clone. Activación vía hook `UserPromptSubmit` que reinyecta el Enfoque activo como `additionalContext`; surte efecto al siguiente turno, sin `/clear`. (El nombre del repo en remoto es `enfoke`; el sistema/marca se llama "Enfoques".)
</proyecto>

<stack>
- **Contenido**: Markdown (definiciones con frontmatter `name` / `description` / `keep-coding-instructions: true`).
- **Tooling**: Bash + coreutils, sin dependencias externas. CI: GitHub Actions.
- **Comandos REALES** (read-only / validación, no build):
  - `bash guiones/validar.sh` — valida integridad del catálogo (VERSIÓN semántica, 7 definiciones esperadas, frontmatter, secciones mínimas, referencias cruzadas con LÉEME.md). Exit 0 ok / 1 fallo.
  - `bash guiones/comprobar-version.sh` — compara versión local vs `origin` (default branch). Exit 0 igual/sin remoto · 3 local por delante · 4 local por detrás.
  - `bash enganches/enganche-version.sh` — wrapper inerte; solo avisa si el local quedó por detrás (exit 4). Pensado para encadenar a un hook, no activo por defecto.
  - CI: `shellcheck guiones/*.sh enganches/*.sh` + `validar.sh` (`.github/workflows/validar.yml`); markdownlint + lychee link-check sobre docs de proyecto (`.github/workflows/ci.yml`).
- **Comandos del harness** (no del repo): `/enfoque list|<palabra>|status|off`, atajos `/<palabra>`.
</stack>

<estado>
- **Activo / reciente**. Último commit 2026-06-18. 10 commits totales, rama `main`, remoto `git@github.com:Alexendros/enfoke.git`.
- Madurez temprana: VERSIÓN `0.2.1`. Historial: v0.1.0 inicial → v0.2.0 integral autocontenido → verificación catálogo + homologación al canon de repositorios estándar (CI, plantillas, ADR).
- **Funcional (inferido, sin ejecutar)**: catálogo completo y coherente; los 7 ficheros esperados existen y cumplen el contrato que `validar.sh` comprueba (frontmatter + sección "Lo que NO se sacrifica"); scripts bash bien formados. Alta probabilidad de pasar la validación. El consumo real (activación de Enfoques) depende del harness en `~/.claude/`, que NO está en este repo y no es verificable aquí.
</estado>

<arquitectura>
```
enfoke/
├── README.md            # portada GitHub; redirige a LÉEME.md
├── LÉEME.md             # documentación canónica (español, fuente de verdad doc)
├── VERSIÓN              # versión semántica del catálogo (0.2.1)
├── definiciones/        # los 7 Enfoques (fuente de verdad del catálogo)
│   ├── conciso · rustir · experto          (genéricos / transversales)
│   └── desarrollador · automatizado · pruebas · entrega  (operativos, en ese orden)
├── documentacion/       # CONCEPTO.md (doctrina) + PLANTILLA-enfoque.md
├── guiones/             # validar.sh, comprobar-version.sh
├── enganches/           # enganche-version.sh (aviso de versión, inerte)
├── docs/                # docs de proyecto + adr/ (MADR 4.0.0)
└── .github/             # workflows ci.yml + validar.yml, plantillas, dependabot, CODEOWNERS
```
Flujo operativo natural de los Enfoques: decidir (`desarrollador`) → automatizar (`automatizado`) → probar (`pruebas`) → entregar (`entrega`); los genéricos se aplican en cualquier punto.
</arquitectura>

<pendiente>
- `ROADMAP.md`: todas las secciones son marcadores `(pendiente)` sin contenido real.
- `CHANGELOG.md`: bloque "[Sin publicar]" vacío (todo `(pendiente)`); fecha de v0.1.0 puesta como `2026-01-01` (no coincide con el primer commit real).
- `docs/`: subcarpetas `guias/` y `referencias/` citadas en `docs/README.md` pero aún inexistentes.
- No hay TODO/FIXME reales en el código; las coincidencias de grep son prosa de las definiciones.
</pendiente>

<notas>
- **Idioma**: todo en español por decisión deliberada (nombres de fichero, carpetas, scripts). `VERSIÓN` lleva tilde; mantenerla.
- **Edición**: el flujo documentado es editar desde IDE (Windsurf) abriendo el repo, NO desde terminal/web. GitHub es la fuente canónica.
- **Crear/modificar un Enfoque**: copiar `documentacion/PLANTILLA-enfoque.md` → `definiciones/<palabra>.md` (nombre `^[a-z0-9-]+$`), rellenar frontmatter, citarlo en LÉEME.md, pasar `validar.sh`, subir VERSIÓN (PATCH retoque / MINOR nuevo). `validar.sh` exige exactamente los 7 nombres catalogados: añadir uno requiere actualizar también el array `ENFOQUES_ESPERADOS` del script.
- **Análisis read-only**: no instalar dependencias, no builds. Validación = scripts bash de arriba.
</notas>
