# ENFOQUES — Actitudes de Agentes IA

> Repositorio canónico del sistema de **ENFOQUES**: actitudes operativas y creativas conmutables en caliente para agentes de IA (Claude Code y compatibles).

## Qué es un ENFOQUE

Un **enfoque** es una actitud de trabajo completa que reconfigura _cómo_ un agente razona, decide y entrega — sin cambiar _qué_ sabe. No es un prompt suelto ni una instrucción puntual: es un comportamiento estructurado (rol, principio núcleo, reglas, formato de salida, líneas rojas) que se activa sobre el agente y permanece vigente hasta que se cambia o se quita.

El concepto nació en el entorno `~/.claude/` de Alexendros y se usa con éxito como **eje ortogonal a la verbosidad**:

- **Enfoque** = _cómo trabajo y entrego_ (este repo).
- **Verbosidad** = _cuánto comunico_ (eje separado, `~/.claude/verbosity/`).

Ambos ejes son independientes: cualquier enfoque combina con cualquier verbosidad.

## Por qué existe

Las herramientas como Claude Code traen un comportamiento por defecto que no siempre encaja con la tarea. Cambiarlo "a mano" en cada turno es frágil y se pierde. Los ENFOQUES resuelven eso:

1. **Conmutación en caliente**: `/enfoque <palabra>` activa la actitud sin reiniciar ni `/clear`.
2. **Persistencia por turno**: un hook reinyecta el enfoque activo en cada turno (el CLI solo carga el estilo nativo una vez al inicio; el hook esquiva esa limitación).
3. **Adhesión garantizada**: las instrucciones del enfoque entran con prioridad sobre el comportamiento de arranque.
4. **Catálogo versionado**: cada actitud es un artefacto revisable y mejorable, no conocimiento volátil.

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

El flujo operativo natural: **decidir** (1) → **automatizar** (2) → **probar** (3) → **entregar** (4). Los genéricos se aplican en cualquier punto.

## Arquitectura

```
~/.claude/
├── enfoque/                    ← FUENTE REAL de las definiciones (.md con frontmatter name/description)
├── output-styles/              ← symlink → enfoque/  (compat. con el estilo nativo del CLI)
├── active-enfoque.md           ← enfoque activo en caliente (lo escribe set-layer.sh, lo inyecta el hook)
├── scripts/set-layer.sh        ← motor: resuelve nombre → copia a active-enfoque.md
├── hooks/prompt-context-router.sh  ← inyecta el enfoque activo en cada turno (UserPromptSubmit)
├── commands/enfoque.md         ← comando genérico /enfoque <palabra>
├── commands/<palabra>.md       ← atajos sueltos (/rustir, /desarrollador…)
└── complementos/enfoques/      ← ESTE REPO (doctrina + versión + sincronización)
    ├── README.md               ← este documento
    ├── VERSION                 ← versión semántica del catálogo
    ├── definiciones → ../../enfoque  (symlink: una sola fuente de verdad)
    ├── doc/                     ← doctrina extendida, plantilla de enfoque, decisiones
    ├── scripts/                 ← check de versión contra el remoto validado
    └── hooks/                   ← hook de validación de versión (inerte sin remoto)
```

**Principio de fuente única**: las definiciones no se duplican. `definiciones/` es un symlink a `~/.claude/enfoque/`, que es lo que `set-layer.sh` lee en caliente. Editar un enfoque = editar un solo fichero.

## Uso

```bash
/enfoque list           # lista los enfoques disponibles
/enfoque <palabra>      # activa (ej. /enfoque rustir)
/rustir                 # atajo suelto equivalente
/enfoque status         # muestra el activo en caliente
/enfoque off            # vuelve al comportamiento nativo
```

El cambio surte efecto en el **siguiente turno** (lo inyecta el hook), sin `/clear`.

## Versionado y sincronización

- `VERSION` sigue versionado semántico (`MAJOR.MINOR.PATCH`).
- El repo se sincroniza con un remoto GitHub (la rama validada es la referencia "online").
- `scripts/check-version.sh` compara la versión local contra la del remoto validado.
- `hooks/version-check.sh` avisa si el local diverge del online — **inerte mientras no exista `origin`** (no molesta durante el desarrollo local).

## Crear o modificar un enfoque

1. Copia `doc/PLANTILLA-enfoque.md` a `definiciones/<palabra>.md`.
2. Rellena frontmatter (`name`, `description`, `keep-coding-instructions: true`) y cuerpo.
3. Crea el atajo en `~/.claude/commands/<palabra>.md` (apunta a `set-layer.sh enfoque <palabra>`).
4. Sube `VERSION` (PATCH si es retoque, MINOR si es enfoque nuevo).
5. Commit + push.
