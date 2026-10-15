# Nota técnica de versión — GAUD 0.1.0 (propuesta)

**Tipo:** versión de desarrollo / documentación  
**Fecha de preparación:** 14 de octubre de 2026  
**Estado:** pendiente de validación funcional

## Resumen

Esta entrega organiza la documentación técnica del sistema GAUD. El repositorio contiene páginas HTML, estilos CSS, módulos JavaScript, endpoints PHP y un esquema MySQL inicial. La documentación describe cómo se relacionan estos componentes y propone criterios de aceptación para las funciones principales.

## Cambios incluidos en la documentación

- Ampliación del README.
- Descripción de requisitos funcionales y no funcionales.
- Diagramas UML conceptuales de casos de uso, componentes y datos.
- Documentación de responsabilidades entre frontend, backend y persistencia.
- Registro de cambios, pendientes y criterios de seguimiento.

## Cambios funcionales

No se declara ningún cambio funcional del código de la aplicación en esta nota. Las modificaciones propuestas corresponden a documentación y deben incorporarse al repositorio cuando se habilite la escritura.

## Aspectos pendientes

- Validación funcional de registro, inicio de sesión, perfil, asignaturas y panel.
- Revisión de controles de acceso y validaciones en servidor.
- Pruebas en diferentes resoluciones y navegadores.
- Comprobación de integridad de la base de datos y del proceso de instalación.
- Revisión de la configuración de producción, sesiones y credenciales.
- Actualización del tablero de GitHub Projects y cierre de Issues solo tras verificar criterios.

## Próximo paso técnico recomendado

Ejecutar un ciclo de pruebas en un entorno local limpio: importar `sql/gaud.sql`, configurar PHP/MySQL, probar registro e inicio de sesión, revisar llamadas de `js/api.js`, comprobar accesos no autenticados y documentar resultados en los Issues #21 y #24. Corregir primero los fallos críticos de seguridad o integridad antes de declarar una versión estable.

## Advertencia

Esta nota no afirma que las pruebas se hayan ejecutado ni que la versión esté lista para producción. La etiqueta oficial debe crearse únicamente después de integrar los cambios y revisar sus resultados.
