#!/usr/bin/env bash
#
# GAUD - Setup automatizado para macOS / Linux (PHP + MySQL/MariaDB + Laravel).
#
# Prepara el proyecto en un equipo nuevo:
#   1. Verifica PHP >= 8.2, Composer y cliente mysql.
#   2. Comprueba que MySQL este corriendo (puerto 3306).
#   3. Ejecuta composer install.
#   4. Crea .env desde .env.example y genera APP_KEY.
#   5. Importa laravel/database/gaud.sql (recrea la BD gaud con datos demo).
#   6. Verifica la conexion a la base de datos.
#   7. Opcional (--serve): arranca php artisan serve y abre el navegador.
#
# Uso:
#   ./setup.sh
#   ./setup.sh --serve
#   ./setup.sh --xampp /Applications/XAMPP --db-password clave
#
# Variables de entorno alternativas:
#   XAMPP_DIR, DB_PASSWORD

set -euo pipefail

XAMPP_DIR="${XAMPP_DIR:-}"
DB_PASSWORD="${DB_PASSWORD:-}"
SERVE=0

usage() {
    cat <<'EOF'
Uso: ./setup.sh [opciones]

Opciones:
  --xampp <ruta>       Ruta de XAMPP/MAMP (para localizar el cliente mysql).
  --db-password <pw>   Contraseña de MySQL (usuario root). Default: vacía.
  --serve              Al terminar, arranca php artisan serve y abre el navegador.
  -h, --help           Muestra esta ayuda.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --xampp)          XAMPP_DIR="$2"; shift 2 ;;
        --xampp=*)        XAMPP_DIR="${1#*=}"; shift ;;
        --db-password)    DB_PASSWORD="$2"; shift 2 ;;
        --db-password=*)  DB_PASSWORD="${1#*=}"; shift ;;
        --serve)          SERVE=1; shift ;;
        -h|--help)        usage; exit 0 ;;
        *) echo "Opción desconocida: $1" >&2; usage; exit 1 ;;
    esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LARAVEL_DIR="$ROOT/laravel"
ENV_FILE="$LARAVEL_DIR/.env"
ENV_EXAMPLE="$LARAVEL_DIR/.env.example"
SQL_FILE="$LARAVEL_DIR/database/gaud.sql"

step() { echo; echo "==> $1"; }
ok()   { echo "    [OK] $1"; }
warn() { echo "    [!] $1"; }
fail() { echo "    [X] $1" >&2; echo; echo "Setup interrumpido. Revisa el mensaje anterior y reintenta." >&2; exit 1; }

port_open() {
    (echo > "/dev/tcp/127.0.0.1/$1") 2>/dev/null
}

get_env() {
    sed -n "s/^$1=//p" "$ENV_FILE" | head -n 1
}

[[ -d "$LARAVEL_DIR" ]] || fail "No se encontró la carpeta laravel/ en $ROOT"

# ---------------------------------------------------------------- 1. prereqs
step "1/6 Verificando prerrequisitos"

command -v php >/dev/null 2>&1 || fail "PHP no encontrado en el PATH. Instala PHP 8.2+ (ej. 'brew install php') y reintenta."
PHP_VERSION="$(php -r 'echo PHP_VERSION;')"
PHP_MAJOR="${PHP_VERSION%%.*}"
PHP_MINOR="$(echo "$PHP_VERSION" | cut -d. -f2)"
if [[ "$PHP_MAJOR" -lt 8 || ( "$PHP_MAJOR" -eq 8 && "$PHP_MINOR" -lt 2 ) ]]; then
    fail "Se requiere PHP >= 8.2 (versión detectada: $PHP_VERSION)"
fi
ok "PHP $PHP_VERSION"

COMPOSER=""
if command -v composer >/dev/null 2>&1; then
    COMPOSER="$(command -v composer)"
    ok "Composer ($COMPOSER)"
elif [[ -d "$LARAVEL_DIR/vendor" ]]; then
    warn "Composer no encontrado en el PATH; se usará la carpeta vendor/ existente."
else
    fail "Composer no encontrado y no existe vendor/. Instala Composer (https://getcomposer.org/) y reintenta."
fi

MYSQL_BIN=""
if command -v mysql >/dev/null 2>&1; then
    MYSQL_BIN="$(command -v mysql)"
elif [[ -n "$XAMPP_DIR" && -x "$XAMPP_DIR/mysql/bin/mysql" ]]; then
    MYSQL_BIN="$XAMPP_DIR/mysql/bin/mysql"
elif [[ -x "/Applications/MAMP/bin/mysql/bin/mysql" ]]; then
    MYSQL_BIN="/Applications/MAMP/bin/mysql/bin/mysql"
elif [[ -x "/Applications/XAMPP/bin/mysql" ]]; then
    MYSQL_BIN="/Applications/XAMPP/bin/mysql"
fi
[[ -n "$MYSQL_BIN" ]] || fail "Cliente mysql no encontrado. Instala MySQL/MariaDB (o pasa --xampp con la ruta correcta)."
ok "mysql ($MYSQL_BIN)"

# ------------------------------------------------------------- 2. services
step "2/6 Verificando servicios (MySQL)"

if port_open 3306; then
    ok "MySQL ya está corriendo (puerto 3306)"
else
    fail "MySQL no está corriendo (puerto 3306 cerrado). Inícialo según tu entorno:
    - Homebrew:  brew services start mysql
    - MAMP:      /Applications/MAMP/bin/startMamp.sh start
    - XAMPP:     /Applications/XAMPP/xampp-start.sh start mysqld"
fi

# ---------------------------------------------------------- 3. dependencies
step "3/6 Instalando dependencias (composer)"

if [[ -n "$COMPOSER" ]]; then
    if ! (cd "$LARAVEL_DIR" && "$COMPOSER" install --no-interaction); then
        fail "composer install terminó con errores"
    fi
    ok "composer install"
else
    warn "vendor/ existente: se omite composer install"
fi

# ------------------------------------------------------------- 4. env file
step "4/6 Configurando entorno (.env)"

if [[ ! -f "$ENV_FILE" ]]; then
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    ok ".env creado desde .env.example"
else
    ok ".env ya existe: se conserva"
fi

if [[ -z "$(get_env APP_KEY)" ]]; then
    if ! (cd "$LARAVEL_DIR" && php artisan key:generate --force); then
        fail "php artisan key:generate terminó con errores"
    fi
    ok "APP_KEY generada"
else
    ok "APP_KEY ya presente"
fi

# ------------------------------------------------------------- 5. database
step "5/6 Importando base de datos (gaud, datos demo)"

MYSQL_ARGS=(-u root)
[[ -n "$DB_PASSWORD" ]] && MYSQL_ARGS+=("-p$DB_PASSWORD")

if ! "$MYSQL_BIN" "${MYSQL_ARGS[@]}" < "$SQL_FILE"; then
    fail "La importación de gaud.sql falló. Verifica que MySQL esté corriendo y la credencial (--db-password)."
fi
ok "gaud.sql importado (BD gaud recreada con datos demo)"

# ------------------------------------------------------------ 6. verify
step "6/6 Verificando instalación"

DB_HOST="$(get_env DB_HOST)";  [[ -n "$DB_HOST" ]]  || DB_HOST="127.0.0.1"
DB_PORT="$(get_env DB_PORT)";  [[ -n "$DB_PORT" ]]  || DB_PORT="3306"
DB_NAME="$(get_env DB_DATABASE)"
DB_USER="$(get_env DB_USERNAME)"
DB_PASS="$(get_env DB_PASSWORD)"

if ! php -r "try { new PDO('mysql:host=$DB_HOST;port=$DB_PORT;dbname=$DB_NAME', '$DB_USER', '$DB_PASS'); echo 'OK'; } catch (Exception \$e) { fwrite(STDERR, \$e->getMessage()); exit(1); }"; then
    fail "No se pudo conectar a la base de datos $DB_NAME"
fi
ok "Conexión BD OK ($DB_NAME)"

# ------------------------------------------------------------------- serve
if [[ "$SERVE" -eq 1 ]]; then
    PORT=8000
    if port_open "$PORT"; then
        PORT=8080
        port_open "$PORT" && fail "Los puertos 8000 y 8080 están ocupados. Libera uno y reintenta con --serve."
    fi
    echo "    Servidor en http://127.0.0.1:$PORT (Ctrl+C para detener)"
    if command -v open >/dev/null 2>&1; then
        open "http://127.0.0.1:$PORT"
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "http://127.0.0.1:$PORT"
    fi
    (cd "$LARAVEL_DIR" && php artisan serve --host=127.0.0.1 --port="$PORT")
fi

echo
echo "Setup completado."
echo "  Para ejecutar:  cd laravel && php artisan serve"
echo "  URL:            http://127.0.0.1:8000"
echo "  Usuario demo:   estudiante@gaud.dev / Gaud2026!"
