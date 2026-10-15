# Requisitos del sistema — GAUD

## 1. Propósito

GAUD busca facilitar la consulta y organización de información académica del estudiante, incluyendo perfil, carrera, asignaturas e inscripciones.

## 2. Alcance de esta versión

La estructura actual del repositorio incluye pantallas de acceso y registro, páginas académicas, módulos JavaScript, endpoints PHP y un esquema MySQL. Este documento registra requisitos funcionales esperados y aspectos que aún deben validarse. No constituye evidencia de que todos estén implementados correctamente.

## 3. Actores

- **Estudiante:** crea una cuenta, inicia sesión y consulta su información académica.
- **Sistema:** valida datos, administra la sesión, obtiene información del servidor y presenta resultados.
- **Base de datos:** almacena usuarios, universidades, carreras, asignaturas e inscripciones.

## 4. Requisitos funcionales

| ID | Requisito | Criterio de aceptación propuesto |
|---|---|---|
| RF-01 | Registro de usuario | El sistema valida los campos obligatorios y evita registrar un correo ya utilizado. |
| RF-02 | Inicio de sesión | Un usuario válido accede a su sesión; las credenciales incorrectas generan un mensaje sin revelar datos sensibles. |
| RF-03 | Cierre y control de sesión | Las páginas protegidas no muestran información privada a una sesión no autenticada. |
| RF-04 | Consulta de perfil | El estudiante autenticado puede consultar sus datos personales y académicos. |
| RF-05 | Consulta de asignaturas | El estudiante puede visualizar las asignaturas asociadas a su carrera. |
| RF-06 | Registro de estado académico | El sistema permite consultar o actualizar el estado de una inscripción según las reglas definidas. |
| RF-07 | Panel académico | El panel presenta información relacionada con el avance y las inscripciones disponibles en el sistema. |
| RF-08 | Comunicación API | El frontend consume los endpoints y procesa respuestas JSON exitosas o de error. |
| RF-09 | Validación de entradas | Los datos se validan tanto en el navegador como en el servidor antes de procesarse. |
| RF-10 | Compatibilidad adaptable | Las páginas se pueden utilizar en pantallas de escritorio, tabletas y teléfonos sin pérdida de contenido. |

## 5. Requisitos no funcionales

- **RNF-01 — Seguridad:** las contraseñas deben almacenarse con hash seguro; no deben guardarse en texto plano.
- **RNF-02 — Privacidad:** un usuario solo debe acceder a sus propios datos y a los recursos autorizados.
- **RNF-03 — Integridad:** la base de datos debe mantener las relaciones y restricciones necesarias.
- **RNF-04 — Usabilidad:** los formularios deben indicar errores de forma clara y accesible.
- **RNF-05 — Mantenibilidad:** la lógica debe mantenerse separada entre interfaz, API y persistencia.
- **RNF-06 — Compatibilidad:** comprobar funcionamiento en navegadores modernos y distintos tamaños de pantalla.
- **RNF-07 — Configuración:** las credenciales de producción deben gestionarse fuera del código público.

## 6. Riesgos y criterios de validación

1. La ruta base de la API (`/GAUD/api`) depende del contexto donde se despliegue el proyecto; debe documentarse la configuración local.
2. Los formularios deben validarse también en PHP; la validación del navegador no es suficiente.
3. Las rutas protegidas necesitan autorización en el servidor, no solo ocultar enlaces en la interfaz.
4. La configuración de base de datos observada corresponde a un entorno local de desarrollo y debe revisarse antes de un despliegue.
5. Las funcionalidades deben marcarse como completadas solo después de ejecutar y registrar pruebas reproducibles.

## 7. Tareas relacionadas en GitHub Issues

- [#8 Validación de prerrequisitos](https://github.com/pako086/GAUD/issues/8)
- [#9 Auditoría de convalidaciones](https://github.com/pako086/GAUD/issues/9)
- [#10 Avance del pensum](https://github.com/pako086/GAUD/issues/10)
- [#12 Acceso móvil y consulta del pensum](https://github.com/pako086/GAUD/issues/12)
- [#21 Validar formularios y entradas](https://github.com/pako086/GAUD/issues/21)
- [#24 Pruebas generales de funcionamiento](https://github.com/pako086/GAUD/issues/24)
