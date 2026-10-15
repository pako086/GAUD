# Arquitectura técnica — GAUD

## 1. Visión general

GAUD utiliza una arquitectura cliente-servidor. La interfaz web se ejecuta en el navegador; el backend PHP procesa solicitudes y consulta la base de datos MySQL mediante PDO.

## 2. Capas

### Presentación (frontend)

- HTML: páginas de inicio de sesión, registro, perfil, asignaturas y panel.
- CSS: estilos compartidos en `css/styles.css`.
- JavaScript: módulos por responsabilidad funcional y un cliente común de API en `js/api.js`.

### Aplicación (backend)

Los scripts de `api/` reciben solicitudes y entregan respuestas JSON. `api/config.php` define la conexión PDO y funciones comunes para responder, leer solicitudes y comprobar autenticación mediante sesión.

### Persistencia

El archivo `sql/gaud.sql` define las tablas iniciales de universidades, carreras, asignaturas, usuarios e inscripciones, además de datos iniciales de prueba.

## 3. Contrato de comunicación

El cliente JavaScript usa métodos HTTP:

- `GET` para consultar información.
- `POST` para crear o ejecutar operaciones.
- `PUT` para actualizar.
- `DELETE` para eliminar.

Las solicitudes que envían datos usan JSON. El cliente espera una respuesta con `ok` y, en caso exitoso, `data`; cuando ocurre un error, se espera `ok: false` y `error`. El cliente usa `credentials: "same-origin"` para mantener las credenciales de sesión del mismo origen.

## 4. Responsabilidades y límites

| Componente | Responsabilidad | No debe asumir |
|---|---|---|
| HTML/CSS | Presentación y estructura accesible | Autorizar operaciones sensibles |
| JavaScript | Interacciones, validación inicial y solicitudes | Ser la única barrera de seguridad |
| Endpoints PHP | Validación de servidor, reglas de negocio y autorización | Confiar ciegamente en datos del navegador |
| PDO/MySQL | Persistencia y restricciones de datos | Decidir reglas de interfaz |
| GitHub Issues/Projects | Seguimiento del trabajo | Sustituir pruebas técnicas |

## 5. Instalación local orientativa

1. Preparar un entorno local compatible con PHP, servidor web y MySQL.
2. Colocar el proyecto en la ruta correspondiente al entorno local; la ruta base del cliente API está definida como `/GAUD/api`.
3. Crear/importar la base de datos usando `sql/gaud.sql`.
4. Ajustar la configuración de conexión en `api/config.php` para el entorno local.
5. Abrir la aplicación desde el servidor web local y probar el registro, el inicio de sesión y las páginas protegidas.
6. Revisar los registros del servidor y la consola del navegador si una solicitud falla.

## 6. Seguridad antes de producción

- Reemplazar las credenciales de desarrollo por configuración privada del entorno.
- No publicar secretos ni credenciales reales en el repositorio.
- Verificar el hash de contraseñas y el manejo de sesiones.
- Comprobar autorización en cada endpoint protegido.
- Validar y normalizar entradas en PHP y usar consultas preparadas.
- Revisar protección CSRF, limitación de intentos, mensajes de error y uso de HTTPS.
- Confirmar que no se exponen datos de otros usuarios.
