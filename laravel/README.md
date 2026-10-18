# GAUD — Sistema de Gestión Académica

**Entrega:** Fase 4  
**Aplicación web completa con frontend HTML5, CSS3, backend en Laravel y base de datos MariaDB/MySQL**

GAUD es un sistema académico web que permite gestionar información universitaria relacionada con estudiantes, universidades, carreras, asignaturas e inscripciones.

La aplicación permite:

- Registrar una cuenta de estudiante.
- Iniciar sesión con validación de credenciales.
- Mantener la sesión activa de forma segura.
- Consultar y actualizar el perfil del usuario.
- Cambiar la contraseña.
- Eliminar la cuenta.
- Visualizar un dashboard académico con progreso, créditos, índice académico y distribución de calificaciones.
- Consultar las asignaturas del plan de estudios.
- Actualizar el estado de cada asignatura: `pendiente`, `en-curso` o `aprobada`.
- Registrar calificaciones `A`, `B` o `C` cuando la asignatura está aprobada.
- Consultar un catálogo público de universidades y carreras.

El proyecto se construyó de manera progresiva durante el trimestre:

| Fase | Enfoque |
|---|---|
| Fase 1 | Estructura visual con HTML5 y CSS |
| Fase 2 | JavaScript, DOM, validaciones y componentes dinámicos |
| Fase 3 | Backend, sesiones, base de datos y CRUD |
| Fase 4 | Integración con framework, ejecución reproducible y documentación profesional |

---

## Tecnologías y versiones

| Tecnología | Versión utilizada | Uso en el proyecto |
|---|---:|---|
| PHP | 8.2.12 | Lenguaje del backend |
| Laravel | 12.70.0 | Framework PHP para rutas, controladores, sesiones, middleware y modelos |
| Composer | 2.10.3 | Gestor de dependencias de PHP |
| MariaDB | 10.4.32 | Base de datos local |
| XAMPP | Compatible con PHP 8.2 | Servidor local con Apache, PHP y MariaDB/MySQL |
| HTML5 | — | Estructura del frontend |
| CSS | — | Estilos del frontend |
| JavaScript | Lógica del frontend, consumo de la API, validaciones y manipulación del DOM |

La aplicación **no requiere Node.js, npm, Vite ni otro build tool** para ejecutarse localmente.

---

## Requisitos previos

Para ejecutar el proyecto necesitas:

1. **XAMPP** u otro entorno local con:
   - PHP 8.2 o superior
   - Apache o servidor PHP
   - MySQL/MariaDB

2. **Composer** instalado y disponible en la terminal.

3. Un **navegador web** moderno.

4. El repositorio clonado o descargado.

No se requiere instalación adicional de frontend.

---

## Estructura del repositorio

```text
GAUD/
├── README.md
└── laravel/
    ├── app/
    │   ├── Http/
    │   │   ├── Controllers/
    │   │   └── Middleware/
    │   ├── Models/
    │   └── Services/
    ├── bootstrap/
    ├── database/
    │   └── gaud.sql
    ├── public/
    │   ├── css/
    │   ├── icon/
    │   ├── js/
    │   ├── index.html
    │   ├── registro.html
    │   ├── dashboard-tommisan.html
    │   ├── asignaturas.html
    │   └── perfil.html
    ├── routes/
    │   └── web.php
    ├── .env.example
    ├── artisan
    └── composer.json
```

Notas importantes:

- La aplicación Laravel está dentro de `laravel/`.
- El frontend estático está en `laravel/public/`.
- El script de base de datos está en `laravel/database/gaud.sql`.
- El proyecto **no usa migrations de Laravel** para crear la base de datos. La fuente de verdad del esquema y datos demo es `laravel/database/gaud.sql`.

---

## Instalación rápida (recomendada)

El proyecto incluye scripts de setup que automatizan la instalación completa en un equipo nuevo: verificar dependencias, iniciar MySQL, configurar `.env`, importar la base de datos y verificar la conexión.

| Sistema | Cómo ejecutar |
|---|---|
| Windows | Doble clic en `setup.bat` (o ejecutar `setup.bat` desde la terminal) |
| macOS / Linux | `./setup.sh` |

### Pasos

```bash
git clone https://github.com/pako086/GAUD.git
cd GAUD
```

Windows:

```bat
setup.bat
```

macOS / Linux:

```bash
./setup.sh
```

El script ejecuta, en orden:

1. Verifica PHP ≥ 8.2, Composer y el cliente `mysql`.
2. Inicia Apache + MySQL si no están corriendo (solo Windows; en macOS/Linux debe iniciarlos usted).
3. Ejecuta `composer install` dentro de `laravel/`.
4. Crea `.env` desde `.env.example` (si no existe) y genera `APP_KEY`.
5. Importa `laravel/database/gaud.sql`: recrea la base de datos `gaud` con las tablas y los datos demo.
6. Verifica la conexión a la base de datos.

Al finalizar, ejecute la aplicación desde `laravel/`:

```bash
php artisan serve
```

Y abra:

```text
http://127.0.0.1:8000
```

### Opciones

| Opción | Windows | macOS / Linux | Descripción |
|---|---|---|---|
| Ruta de XAMPP | `setup.bat -XamppPath D:\xampp` | `./setup.sh --xampp /ruta/a/xampp` | Default: `C:\xampp` (Windows) |
| Contraseña de MySQL | `setup.bat -DbPassword "clave"` | `./setup.sh --db-password clave` | Default: vacía (XAMPP por defecto) |
| Servidor al terminar | `setup.bat -Serve` | `./setup.sh --serve` | Arranca `php artisan serve` (puerto 8000, fallback 8080) y abre el navegador |


> **Advertencia:** el script elimina y vuelve a crear las tablas. Si lo importas nuevamente, los datos actuales de la base de datos `gaud` se reemplazarán por los datos demo.

---

### 4. Instalar dependencias y configurar la aplicación

Entra a la carpeta Laravel:

```bash
cd laravel
```

Opción rápida:

```bash
composer setup
```

Este comando ejecuta:

```bash
composer install
```

Copia `.env.example` a `.env` si `.env` no existe y genera la clave de la aplicación.

Si prefieres hacerlo paso a paso:

```bash
composer install
```

Luego crea el archivo de entorno:

```bash
# Windows
copy .env.example .env

# Linux/macOS
cp .env.example .env
```

Genera la clave de la aplicación:

```bash
php artisan key:generate
```

---

### 5. Verificar configuración de base de datos

Abre el archivo:

```text
laravel/.env
```

Asegúrate de que los valores de base de datos coincidan con tu entorno local.

Con la configuración predeterminada de XAMPP, normalmente serán:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=gaud
DB_USERNAME=root
DB_PASSWORD=
```

Si tu MySQL/MariaDB usa una contraseña diferente, actualiza:

```env
DB_PASSWORD=tu_contraseña
```

Guarda el archivo.

---

### 6. Ejecutar la aplicación

Desde la carpeta `laravel/`:

```bash
php artisan serve
```

Alternativamente:

```bash
composer dev
```

La aplicación normalmente quedará disponible en:

```text
http://127.0.0.1:8000
```

Si el puerto `8000` está ocupado:

```bash
php artisan serve --port=8080
```

Y accede a:

```text
http://127.0.0.1:8080
```

---

## Usuario de demostración

El script SQL incluye un usuario de demostración.

| Campo | Valor |
|---|---|
| Correo | `estudiante@gaud.dev` |
| Contraseña | `Gaud2026!` |

Este usuario permite probar:

- Inicio de sesión.
- Dashboard académico.
- Asignaturas.
- Perfil.
- Cambio de contraseña.
- Actualización de estado de asignaturas.
- Cierre de sesión.

---

## Uso de la aplicación

1. Abre la aplicación en el navegador.
2. Inicia sesión con el usuario demo o crea una cuenta nueva.
3. Tras iniciar sesión, accedes al dashboard académico.
4. Desde el dashboard puedes revisar:
   - Progreso general.
   - Créditos ganados.
   - Créditos totales.
   - Asignaturas aprobadas.
   - Asignaturas en curso.
   - Asignaturas pendientes.
   - Índice académico.
   - Distribución de calificaciones.
5. En la sección de asignaturas puedes actualizar el estado de cada materia.
6. En el perfil puedes actualizar datos personales, cambiar la contraseña o eliminar la cuenta.

---

## Base de datos

La base de datos se llama:

```text
gaud
```

Contiene las siguientes tablas:

| Tabla | Descripción |
|---|---|
| `universidades` | Universidades disponibles en el catálogo |
| `carreras` | Carreras ofrecidas por cada universidad |
| `asignaturas` | Asignaturas del plan de estudios |
| `usuarios` | Estudiantes registrados |
| `inscripciones` | Relación entre usuarios y asignaturas, con estado y calificación |

### Relaciones principales

- Una universidad puede ofrecer muchas carreras.
- Una carrera puede tener muchas asignaturas.
- Un usuario pertenece a una universidad y a una carrera.
- Un usuario puede estar inscrito en muchas asignaturas.
- Una asignatura puede estar inscrita por muchos usuarios.
- La tabla `inscripciones` guarda el estado académico y la calificación de cada usuario por asignatura.

### Datos de prueba

El script SQL incluye datos de ejemplo para:

- Universidad Abierta Para Adultos.
- Carrera de Ingeniería en Software.
- Asignaturas del plan de estudios.
- Usuario de demostración.
- Inscripciones de ejemplo para el usuario demo.

---

## API

La API se sirve bajo:

```text
/api
```

Las rutas conservan el sufijo `.php` para mantener compatibilidad con el frontend desarrollado en fases anteriores.

Formato de respuesta:

Éxito:

```json
{
  "ok": true,
  "data": {}
}
```

Error:

```json
{
  "ok": false,
  "error": "Mensaje de error"
}
```

### Endpoints

| Método | Ruta | Autenticación | Descripción |
|---|---|---:|---|
| `GET` | `/api/auth.php` | Sí | Obtiene el usuario autenticado |
| `POST` | `/api/auth.php` | No | Inicia sesión |
| `POST` | `/api/auth.php?action=logout` | Sí | Cierra la sesión |
| `POST` | `/api/usuarios.php` | No | Crea una cuenta nueva |
| `GET` | `/api/usuarios.php` | Sí | Obtiene el perfil del usuario autenticado |
| `PUT` | `/api/usuarios.php` | Sí | Actualiza el perfil del usuario |
| `PUT` | `/api/usuarios.php?action=password` | Sí | Cambia la contraseña |
| `DELETE` | `/api/usuarios.php` | Sí | Elimina la cuenta del usuario autenticado |
| `GET` | `/api/catalogo.php` | No | Obtiene universidades y carreras |
| `GET` | `/api/dashboard.php` | Sí | Obtiene el resumen académico del usuario |
| `GET` | `/api/asignaturas.php` | Sí | Obtiene asignaturas con estado del usuario |
| `PUT` | `/api/asignaturas.php` | Sí | Actualiza estado o calificación de una asignatura |

### Estados de asignatura

Los estados permitidos son:

```text
pendiente
en-curso
aprobada
```

Las calificaciones permitidas son:

```text
A
B
C
```

---

## Conceptos de Laravel aplicados

### Rutas

Las rutas se definen en:

```text
laravel/routes/web.php
```

Laravel recibe las peticiones HTTP y las dirige hacia los controladores correspondientes.

### Controladores

La lógica de la API está organizada en controladores dentro de:

```text
laravel/app/Http/Controllers/
```

Controladores principales:

| Controlador | Responsabilidad |
|---|---|
| `AuthController` | Login, logout y usuario autenticado |
| `UserController` | Registro, perfil, actualización, contraseña y eliminación de cuenta |
| `CatalogoController` | Catálogo público de universidades y carreras |
| `DashboardController` | Resumen académico del usuario |
| `AsignaturaController` | Consulta y actualización de asignaturas/inscripciones |

### Middleware

Las rutas privadas usan middleware para verificar que el usuario esté autenticado antes de ejecutar el controlador.

### Modelos y base de datos

Los modelos Eloquent están en:

```text
laravel/app/Models/
```

Laravel se encarga de interactuar con la base de datos mediante los modelos y las relaciones definidas.

### Inyección de dependencias

La aplicación usa inyección de dependencias por constructor.

Por ejemplo, los controladores que necesitan cálculos académicos reciben la clase `Academico` a través del constructor:

```php
public function __construct(protected Academico $academico)
{
}
```

El contenedor de Laravel resuelve automáticamente esa dependencia.

### Sesiones

La aplicación usa sesiones de Laravel para mantener al usuario autenticado.

Durante el login:

- Se valida el correo y la contraseña.
- Se inicia la sesión.
- Se regenera la sesión para evitar fijación de sesión.

Durante el logout:

- Se cierra la sesión.
- Se invalida la sesión.
- Se regenera el token CSRF.

---

## Integrantes del equipo

| Integrante | Rol |
|---|---|
| `Fidel Ernesto Arias Garcia` | `Full Stack Dev` |
