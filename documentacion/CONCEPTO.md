# El concepto Enfoques — doctrina

> **Nota de nomenclatura**: **Enfoques** (con mayúscula) es el nombre propio de la herramienta/sistema. **Enfoque** (con mayúscula) es cada actitud concreta del catálogo (el Enfoque Rustir, el Enfoque Entrega). En minúscula, "enfoque" solo cuando se habla del concepto genérico de poner el foco en algo.

## Origen

El sistema Enfoques surgió en `~/.claude/` como respuesta a un problema concreto: el comportamiento por defecto de Claude Code (su "output style") se carga **una sola vez al inicio de sesión** y cambiarlo requería `/clear` o reinicio. Eso hacía inviable adaptar la actitud del agente a la tarea sobre la marcha.

La solución fue desacoplar la *actitud* del *arranque*: definir cada actitud como un artefacto independiente y reinyectarla por turno mediante un hook `UserPromptSubmit`. Así nació el eje **Enfoque**, y por simetría el eje **verbosidad**.

## Los dos ejes ortogonales

| Eje            | Pregunta que responde      | Ejemplos                       |
| -------------- | -------------------------- | ------------------------------ |
| **Enfoque**    | ¿*Cómo* trabajo y entrego? | Rustir, Desarrollador, Entrega |
| **Verbosidad** | ¿*Cuánto* comunico?        | Modo Funcionario Gris          |

Son independientes: el Enfoque define la *postura* (crítico, ejecutor, planificador), la verbosidad define el *volumen* (lacónico, detallado). Se combinan libremente.

## Anatomía de un Enfoque

Cada Enfoque es un `.md` con frontmatter + cuerpo estructurado:

```yaml
---
name: <Nombre legible>           # identificador que muestra el CLI como estilo activo
description: <una línea>          # qué hace; se ve en la lista de comandos
keep-coding-instructions: true   # conserva las instrucciones base de coding del CLI
---
```

El cuerpo sigue un patrón probado:

1. **Rol / identidad** — quién eres bajo este Enfoque.
2. **Principio núcleo** — la idea-fuerza en negrita, una frase.
3. **Comportamientos** — reglas numeradas, accionables.
4. **Formato de salida** — plantilla concreta cuando el Enfoque tiene una estructura de entrega fija (informe, dossier, memoria…).
5. **Qué evitar** — antipatrones explícitos.
6. **Cuándo usarlo** — situaciones diana.
7. **Lo que NO se sacrifica** — líneas rojas que ningún Enfoque cruza (honestidad epistémica, reportar fielmente, idioma del operador).

## Genéricos vs operativos

- **Genéricos**: actitudes transversales que no corresponden a una fase concreta de un trabajo. Se aplican en cualquier momento (Conciso, Rustir, Experto).
- **Operativos**: actitudes ligadas a una etapa del ciclo de un trabajo, con orden natural de ejecución:
  1. Desarrollador — decide la estrategia y dirige.
  2. Automatizado — construye los flujos.
  3. Pruebas — valida lo construido.
  4. Entrega — despliega el MVP.

## Adhesión — por qué el Enfoque "manda"

El hook `prompt-context-router.sh` inyecta el cuerpo del Enfoque activo como `additionalContext` con un encabezado que declara prioridad sobre el output style de arranque. Mientras `active-enfoque.md` exista y tenga contenido, su comportamiento prevalece. `set-layer.sh enfoque off` borra ese fichero y el agente vuelve al nativo.

Esto **no** es coerción a nivel de modelo (ningún hook puede forzar tokens concretos), sino reinyección de instrucciones de alta prioridad en cada turno. La adhesión es tan fuerte como la disciplina del agente para seguir instrucciones de sistema — que en Claude Code es alta.

## Líneas rojas comunes a todos los Enfoques

Ningún Enfoque, por agresivo que sea, sacrifica:

- **Honestidad epistémica**: distinguir hipótesis de afirmación; marcar lo no verificado.
- **Reporte fiel**: fallo → mostrarlo con su salida; paso omitido → decirlo; "hecho" solo tras verificar.
- **Idioma y convenciones del operador**: castellano técnico de España, ortografía completa.
