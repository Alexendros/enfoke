# 0001. Usar MADR como formato para decisiones de arquitectura

- Estado: accepted
- Fecha: 2026-01-01
- Decisores: Alejandro · Iniciativas Alexendros
- Etiquetas: arquitectura, documentación

> Texto en formato MADR 4.0.0 · https://adr.github.io/madr/

## Contexto y planteamiento del problema

El repositorio enfoke necesita un mecanismo para registrar las decisiones
de arquitectura y diseño de forma trazable, consultable y ligera. Sin un
formato acordado, las decisiones quedan dispersas en commits, PRs o notas
informales y se pierden con el tiempo.

## Drivers de la decisión

- Formato ligero en Markdown, versionable en git.
- Adoptado ampliamente en la comunidad de ingeniería de software.
- Compatible con la metodología de trabajo del proyecto.

## Opciones consideradas

- MADR 4.0.0 (Markdown Any Decision Records)
- RFC clásico en formato libre
- Sin registro formal de decisiones

## Resultado de la decisión

Opción elegida: "MADR 4.0.0", porque es ligero, está estandarizado, se
integra directamente en el repositorio como ficheros Markdown y está
soportado por herramientas del ecosistema.

### Consecuencias positivas

- Las decisiones quedan versionadas junto al código y la documentación.
- El formato es predecible y fácil de leer sin herramientas especiales.

### Consecuencias negativas

- Requiere disciplina del equipo para mantener el directorio actualizado.

## Validación

La presencia de ADRs en `docs/adr/` con campos `status:` y `fecha:` se
verifica en CI mediante el validador de canon del repositorio.

## Pros y contras de las opciones

### MADR 4.0.0

- Bueno, porque es Markdown puro, sin dependencias externas.
- Bueno, porque tiene estructura mínima pero suficiente.
- Malo, porque requiere acordar el flujo de actualización de estado.

### RFC en formato libre

- Bueno, porque da más libertad narrativa.
- Malo, porque sin estructura fija la consulta posterior es más difícil.

## Más información

- https://adr.github.io/madr/
- https://docs.github.com/en/repositories
