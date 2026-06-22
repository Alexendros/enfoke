# Enfoques — Actitudes de Agentes IA

> Repositorio canónico de **enfoke**: actitudes operativas y creativas conmutables en caliente para agentes de IA (Claude Code y compatibles).

---

## Qué es un _enfoke_

Un **enfoke** es una actitud de trabajo completa que reconfigura _cómo_ un agente razona, decide y entrega — sin cambiar _qué_ sabe. No es un prompt suelto ni una instrucción puntual: es un comportamiento estructurado (rol, principio núcleo, reglas, formato de salida, líneas rojas) que se activa sobre el agente y permanece vigente hasta que se cambia o se quita.

> **Nomenclatura**: **Enfoques** (mayúscula) = el sistema/herramienta. **Enfoque** (mayúscula) = una actitud concreta del catálogo. En minúscula solo el concepto genérico de poner el foco en algo.

El concepto nació en el entorno `~/.claude/` de Alexendros y se usa con éxito como **eje ortogonal a la verbosidad**:

- **Enfoke** = _cómo trabajo y entrego_ (este repo).
- **Verbosidad** = _cuánto comunico_ (eje separado).

Ambos ejes son independientes: cualquier Enfoque combina con cualquier verbosidad. La Verbosidad es un eje separado y **no se entrega en este repositorio** (aquí solo viven los Enfoques).

## Repositorio integral — clonar es tener

Este repo es **autocontenido**: las definiciones reales viven dentro (`definiciones/*.md`), no son enlaces a ningún sitio externo. Clonarlo te da el contexto completo del sistema integrado — un agente de código que clone este repo conoce todos los Enfoques sin nada más.

- **GitHub es la fuente canónica**: de aquí se descarga y se usa.
- **Las modificaciones se hacen en un IDE** (Windsurf), abriendo el repo como workspace. Nunca desde terminal/CLI/web.
- **El harness consume, no edita**: Claude Code lee las definiciones a través de su motor; no es donde se tocan.

Si un agente o herramienta descarga este repo y solo usa una parte (p. ej. ignora los guiones de versión), no pasa nada: las partes no funcionales para ese consumidor se obvian, y el resto da contexto global del sistema.

## Catálogo

### Genéricos (actitud transversal, sin orden de ejecución)

| Palabra   | Actitud                                                                               |
| --------- | ------------------------------------------------------------------------------------- |
| `conciso` | Densidad sin pérdida de razonamiento, contexto ni calidad.                            |
| `rustir`  | Crítica brutal, sin anestesia ni tabúes, pero informada y honesta. Abre con hornillo. |
| `experto` | Revisión crítica con informe formal (mejoras, correcciones, cambios, sugerencias).    |

### Operativos (orden natural de ejecución de un trabajo)

| #   | Palabra         | Actitud                                                                                               |
| --- | --------------- | ----------------------------------------------------------------------------------------------------- |
| 1   | `desarrollador` | Razona estrategia y fija fases con validadores. **Dirige; no codifica** (lo hacen agentes).           |
| 2   | `automatizado`  | Diseña/aplica/mantiene flujos y tareas (repos, daemons, cron, webhooks…). Cierra con memoria-informe. |
| 3   | `pruebas`       | Valida código preexistente: testing + hardening estilo equipos de ciberseguridad.                     |
| 4   | `entrega`       | Optimiza y despliega el MVP; mapea las tareas pendientes para fases posteriores.                      |

Flujo operativo natural: **decidir** (1) → **automatizar** (2) → **probar** (3) → **entregar** (4). Los genéricos se aplican en cualquier punto.

## Estructura del repositorio

```text
enfoques/
├── VERSIÓN                 ← versión semántica del catálogo
├── definiciones/           ← los 7 Enfoques, ficheros reales (fuente de verdad)
│   ├── conciso.md
│   ├── rustir.md
│   ├── experto.md
│   ├── desarrollador.md
│   ├── automatizado.md
│   ├── pruebas.md
│   └── entrega.md
├── documentacion/
│   ├── CONCEPTO.md         ← doctrina extendida (origen, anatomía, adhesión)
│   └── PLANTILLA-enfoque.md← plantilla para crear un Enfoque nuevo
├── guiones/
│   ├── comprobar-version.sh← compara versión local vs remoto validado (online)
│   └── validar.sh          ← valida integridad del catálogo (frontmatter, versión, referencias)
├── enganches/
│   └── enganche-version.sh ← aviso inerte si la copia local quedó por detrás del online
└── .github/
    └── workflows/
        └── validar.yml     ← CI: shellcheck + validar.sh en cada push/PR
```

## Cómo lo consume Claude Code (el harness)

El motor vive en el harness (`~/.claude/`), **no en este repo**, y lee las definiciones **directamente de este repo** desde donde se clone (la carpeta `definiciones/`). No hay copias en `~/.claude/`: el motor se adapta al repo, no al revés.

```text
/enfoque list           # lista los Enfoques (desde definiciones/)
/enfoque <palabra>      # activa (ej. /enfoque rustir)
/rustir                 # atajo suelto equivalente
/enfoque status         # muestra el activo en caliente
/enfoque off            # vuelve al comportamiento nativo
```

El cambio surte efecto en el **siguiente turno**: un hook `UserPromptSubmit` reinyecta el cuerpo del Enfoque activo como `additionalContext` (mecanismo oficial documentado en [Claude Code hooks](https://code.claude.com/docs/en/hooks)), sin `/clear`.

## Versionado y sincronización

- `VERSIÓN` sigue versionado semántico (`MAJOR.MINOR.PATCH`).
- La rama por defecto de `origin` (GitHub) es la referencia "online" validada.
- `guiones/comprobar-version.sh` compara la versión local contra la del remoto validado.
- `enganches/enganche-version.sh` avisa si el local quedó por detrás del online — **inerte mientras no exista `origin`** (no molesta durante el desarrollo).
- `guiones/validar.sh` valida la integridad del catálogo (frontmatter, formato de `VERSIÓN`, referencias cruzadas); lo ejecuta también la CI de GitHub Actions en cada push y PR.

## Crear o modificar un Enfoque

Desde el IDE (Windsurf), abriendo este repo:

1. Copia `documentacion/PLANTILLA-enfoque.md` a `definiciones/<palabra>.md`.
2. Rellena frontmatter (`name`, `description`, `keep-coding-instructions: true`) y cuerpo.
3. Crea el atajo `/<palabra>` en el harness. La vía recomendada hoy son los [skills](https://code.claude.com/docs/en/skills) (`~/.claude/skills/<palabra>/SKILL.md`); el formato legacy `~/.claude/commands/<palabra>.md` sigue funcionando.
4. Pasa el validador: `bash guiones/validar.sh`.
5. Sube `VERSIÓN` (PATCH si es retoque, MINOR si es Enfoque nuevo).
6. Commit + push a GitHub.
