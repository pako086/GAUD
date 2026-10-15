# Gestión del proyecto — GAUD

## 1. Herramienta

El seguimiento se organiza mediante GitHub Issues y GitHub Projects. Se describe un objetivo claro, criterios de aceptación y evidencia de validación cuando corresponde.

## 2. Estados recomendados del tablero

Mantener las columnas establecidas en el proyecto:

- **Backlog:** ideas o mejoras sin priorizar para el ciclo actual.
- **Por hacer:** tareas seleccionadas y listas para comenzar.
- **En progreso:** trabajo que se está realizando.
- **En revisión:** trabajo terminado por el responsable y pendiente de comprobación.
- **Finalizado:** tarea verificada y aceptada.

El estado de un Issue abierto no indica automáticamente en qué columna está. Debe comprobarse el tablero y actualizarse manualmente según el trabajo real.

## 3. Cuatro Issues para seguimiento de riesgos y pendientes

| Tipo | Issue | Motivo de seguimiento | Criterio para cerrar |
|---|---|---|---|
| Documentación pendiente | [#4 Elaborar documentación técnica](https://github.com/pako086/GAUD/issues/4) | Faltaba documentar arquitectura, requisitos y alcance. | Documentación revisada y enlazada desde README. |
| Mejora de interfaz | [#18 Ajustar CSS y diseño responsivo](https://github.com/pako086/GAUD/issues/18) | Riesgo de diferencias entre tamaños de pantalla. | Verificación en móvil, tableta y escritorio sin pérdida de contenido. |
| Validación / seguridad | [#21 Validar formularios y entradas](https://github.com/pako086/GAUD/issues/21) | Las entradas deben comprobarse en cliente y servidor. | Pruebas con campos vacíos, formatos inválidos, duplicados y solicitudes manipuladas. |
| Riesgo de calidad | [#24 Realizar pruebas generales](https://github.com/pako086/GAUD/issues/24) | No se debe asumir que el conjunto funciona sin pruebas. | Casos ejecutados, resultados registrados y errores críticos resueltos. |

## 4. Otras tareas existentes relevantes

- [#22 Compatibilidad en diferentes resoluciones](https://github.com/pako086/GAUD/issues/22)
- [#23 Optimizar imágenes y recursos multimedia](https://github.com/pako086/GAUD/issues/23)
- [#19 Integrar visor de publicaciones PDF](https://github.com/pako086/GAUD/issues/19)
- [#8 Validación de prerrequisitos](https://github.com/pako086/GAUD/issues/8)
- [#10 Visualización del avance del pensum](https://github.com/pako086/GAUD/issues/10)
- [#12 Acceso móvil y consulta rápida del pensum](https://github.com/pako086/GAUD/issues/12)

## 5. Reglas de actualización

1. Mover una tarea a **En progreso** solo cuando el trabajo haya comenzado.
2. Usar **En revisión** cuando exista un cambio que otra persona o una prueba deba validar.
3. Mover a **Finalizado** solo después de verificar los criterios de aceptación.
4. Mantener Issues abiertos mientras existan pendientes.
5. Enlazar commits o pull requests con los Issues correspondientes.
6. Añadir al Issue los resultados de pruebas y cualquier limitación conocida.
