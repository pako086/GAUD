# GAUD — Gestión Académica Universitaria Dominicana

GAUD es un sistema web académico orientado a estudiantes universitarios. Su propósito es reunir información de la carrera, las asignaturas y el progreso académico en una interfaz organizada, para facilitar la consulta y la planificación de los estudios.

> **Estado:** versión inicial de desarrollo (0.1.0 propuesta). Esta documentación describe la estructura observada del repositorio; las funcionalidades deben validarse mediante pruebas antes de considerarse terminadas.

## Problema que aborda

La información sobre asignaturas, períodos, inscripciones y avance de la carrera puede resultar difícil de organizar cuando se consulta desde distintas fuentes. GAUD busca ofrecer un punto de consulta centralizado para que el estudiante pueda revisar su información académica y planificar los siguientes pasos de su trayectoria.

## Funcionalidades y componentes

La estructura del repositorio incluye:

- Páginas web para las secciones principales del sistema.
- Módulos JavaScript para comunicación con la API, asignaturas, panel académico, perfil, usuarios, fechas, encabezado y validaciones.
- Endpoints PHP para autenticación, usuarios, catálogo, asignaturas y panel académico.
- Esquema SQL para universidades, carreras, asignaturas, usuarios e inscripciones.
- Gestión del avance y de las tareas mediante GitHub Issues y GitHub Projects.

La presencia de un archivo o módulo no significa por sí sola que todas sus funciones estén probadas. El estado funcional debe confirmarse mediante pruebas.

## Arquitectura seleccionada

GAUD utiliza una arquitectura web cliente-servidor de tres partes lógicas:

1. **Frontend:** HTML y CSS construyen la interfaz; JavaScript gestiona interacciones, validaciones del lado del cliente y solicitudes a la API.
2. **Backend:** scripts PHP reciben solicitudes, aplican lógica de aplicación y devuelven respuestas JSON. La configuración compartida se encuentra en `api/config.php`; incluye acceso a datos mediante PDO y comprobación de sesión para operaciones protegidas.
3. **Base de datos:** MySQL almacena la información estructurada. El esquema inicial se encuentra en `sql/gaud.sql`.

### Organización del frontend

- Las páginas HTML representan las pantallas de la aplicación.
- `css/` contiene los estilos visuales.
- `js/api.js` centraliza las solicitudes HTTP a los endpoints PHP y procesa respuestas JSON.
- Los demás módulos de `js/` agrupan comportamientos de áreas como usuarios, perfil, asignaturas, panel y validaciones.
- `icon/` contiene recursos visuales usados por la interfaz.

### Organización del backend

- `api/auth.php`: operaciones relacionadas con autenticación.
- `api/usuarios.php`: operaciones de usuarios.
- `api/asignaturas.php`: operaciones sobre asignaturas e inscripciones.
- `api/catalogo.php`: información de catálogo.
- `api/dashboard.php`: datos para el panel académico.
- `api/config.php`: conexión PDO, respuestas JSON, lectura de solicitudes y comprobación de autenticación.
- `sql/gaud.sql`: creación y datos iniciales de la base de datos.

Estos nombres describen la organización observada en el repositorio; el alcance exacto de cada endpoint debe comprobarse con pruebas y revisión del código.

### Comunicación entre frontend y backend

El frontend utiliza la API definida en `js/api.js`, con solicitudes HTTP (`GET`, `POST`, `PUT` y `DELETE`) a rutas bajo `/GAUD/api`. Los datos enviados se serializan como JSON cuando corresponde. El backend responde en JSON con una estructura común: `ok: true` y `data` para resultados, o `ok: false` y `error` para errores. Las solicitudes que requieren autenticación utilizan credenciales de la misma sesión.

La base de datos se consulta desde el backend mediante PDO. Las credenciales y la configuración del entorno deben mantenerse fuera de repositorios públicos en un despliegue real; los valores de desarrollo actuales deben revisarse antes de publicar el sistema en producción.

## Tecnologías y herramientas

- **HTML5:** estructura de páginas.
- **CSS3:** presentación y diseño adaptable.
- **JavaScript:** interacciones y comunicación con la API.
- **PHP:** endpoints y lógica del servidor.
- **MySQL:** almacenamiento relacional.
- **PDO:** acceso a datos desde PHP.
- **Git y GitHub:** control de versiones y alojamiento del código.
- **GitHub Issues / Projects:** seguimiento de incidencias y tareas.

## Estructura relevante

```text
GAUD/
├── api/          # Endpoints PHP
├── css/          # Estilos
├── icon/         # Recursos visuales
├── js/           # Lógica del frontend y cliente API
├── sql/          # Esquema y datos iniciales
├── index.html    # Página de inicio de sesión
├── registro.html # Registro de usuarios
├── perfil.html   # Perfil del estudiante
├── asignaturas.html # Grid visual del Pensum del estudiante
├── dashboard-tommisan.html # Pagina inicial con el resumen del perfil del estudiante
└── README.md
```

## Documentación técnica

- [Requisitos del sistema](docs/requisitos.md)
- [Modelos UML](docs/modelos-uml.md)
- [Arquitectura técnica](docs/arquitectura.md)
- [Gestión del proyecto](docs/gestion-proyecto.md)
- [Registro de cambios](docs/registro-cambios.md)
- [Nota técnica de versión](docs/nota-tecnica-version.md)

## Estado actual y limitaciones

El repositorio contiene componentes de frontend, endpoints PHP y un esquema MySQL inicial. La entrega se considera una versión de desarrollo, no una versión de producción. Antes de darla por terminada es necesario ejecutar pruebas funcionales, revisar validaciones y permisos, confirmar el diseño adaptable, verificar la instalación de la base de datos y documentar los resultados.

También debe revisarse la configuración de seguridad, incluyendo credenciales de base de datos, gestión de sesiones, autorización, validación del lado del servidor y protección frente a solicitudes no autorizadas.

## Próximos pasos

1. Ejecutar y registrar pruebas de autenticación, formularios, asignaturas y panel.
2. Verificar el esquema y los datos iniciales de MySQL en un entorno limpio.
3. Revisar accesibilidad, mensajes de error y compatibilidad móvil.
4. Completar y mantener actualizados los diagramas y requisitos.
5. Revisar las incidencias abiertas y mover las tareas de GitHub Projects según el avance real.
6. Preparar una versión etiquetada después de validar los cambios.

## Control de versiones

Los cambios se gestionan con commits descriptivos en Git. La versión inicial propuesta para esta entrega es **0.1.0**; la etiqueta o publicación definitiva debe realizarse una vez comprobado el contenido incluido y las pruebas ejecutadas.
