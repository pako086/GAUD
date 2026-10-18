#Requires -Version 5.1
<#
.SYNOPSIS
    GAUD - Setup automatizado para Windows (XAMPP + Laravel).

.DESCRIPTION
    Prepara el proyecto en un equipo nuevo:
      1. Verifica PHP >= 8.2, Composer y XAMPP.
      2. Inicia Apache + MySQL si no están corriendo.
      3. Ejecuta composer install.
      4. Crea .env desde .env.example y genera APP_KEY.
      5. Importa laravel/database/gaud.sql (recrea la BD gaud con datos demo).
      6. Verifica la conexión a la base de datos.
      7. Opcional (-Serve): arranca php artisan serve y abre el navegador.

.PARAMETER XamppPath
    Ruta de la instalación de XAMPP. Default: C:\xampp

.PARAMETER DbPassword
    Contraseña de MySQL (usuario root). Default: vacía (XAMPP por defecto).

.PARAMETER Serve
    Al terminar, arranca "php artisan serve" y abre el navegador.

.EXAMPLE
    .\setup.bat
    .\setup.bat -Serve
    .\setup.bat -XamppPath D:\xampp -DbPassword "clave"
#>
param(
    [string]$XamppPath = "C:\xampp",
    [string]$DbPassword = "",
    [switch]$Serve
)

$ErrorActionPreference = "Stop"

function Step($msg)  { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Ok($msg)    { Write-Host "    [OK] $msg" -ForegroundColor Green }
function Warn($msg)  { Write-Host "    [!] $msg" -ForegroundColor Yellow }
function Fail($msg)  {
    Write-Host "    [X] $msg" -ForegroundColor Red
    Write-Host "`nSetup interrumpido. Revisa el mensaje anterior y reintenta." -ForegroundColor Red
    exit 1
}

function Test-Port([int]$Port, [string]$Computer = "127.0.0.1") {
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $ar = $client.BeginConnect($Computer, $Port, $null, $null)
        if ($ar.AsyncWaitHandle.WaitOne(700) -and $client.Connected) {
            $client.EndConnect($ar)
            return $true
        }
        return $false
    } catch {
        return $false
    } finally {
        $client.Close()
    }
}

function Read-EnvFile([string]$Path) {
    $map = @{}
    foreach ($line in Get-Content -LiteralPath $Path) {
        if ($line -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$') {
            $val = $Matches[2].Trim()
            if ($val.Length -ge 2) {
                $first = $val.Substring(0, 1)
                $last  = $val.Substring($val.Length - 1)
                if (($first -eq '"' -and $last -eq '"') -or ($first -eq "'" -and $last -eq "'")) {
                    $val = $val.Substring(1, $val.Length - 2)
                }
            }
            $map[$Matches[1]] = $val
        }
    }
    return $map
}

$Root       = $PSScriptRoot
$LaravelDir = Join-Path $Root "laravel"
$EnvFile    = Join-Path $LaravelDir ".env"
$EnvExample = Join-Path $LaravelDir ".env.example"
$SqlFile    = Join-Path $LaravelDir "database\gaud.sql"
$VendorDir  = Join-Path $LaravelDir "vendor"

if (-not (Test-Path $LaravelDir)) {
    Fail "No se encontró la carpeta laravel/ en $Root"
}

# ---------------------------------------------------------------- 1. prereqs
Step "1/6 Verificando prerrequisitos"

$PhpExe = $null
$cmd = Get-Command php -ErrorAction SilentlyContinue
if ($cmd) {
    $PhpExe = $cmd.Source
} elseif (Test-Path (Join-Path $XamppPath "php\php.exe")) {
    $PhpExe = Join-Path $XamppPath "php\php.exe"
}
if (-not $PhpExe) {
    Fail "PHP no encontrado. Instala PHP 8.2+ o XAMPP, o usa -XamppPath con la ruta correcta."
}
$PhpVersion = (& $PhpExe -r "echo PHP_VERSION;").Trim()
$parts = $PhpVersion.Split(".")
if ([int]$parts[0] -lt 8 -or ([int]$parts[0] -eq 8 -and [int]$parts[1] -lt 2)) {
    Fail "Se requiere PHP >= 8.2 (versión detectada: $PhpVersion)"
}
Ok "PHP $PhpVersion ($PhpExe)"

$ComposerExe = $null
$cmd = Get-Command composer -ErrorAction SilentlyContinue
if ($cmd) {
    $ComposerExe = $cmd.Source
}
if ($ComposerExe) {
    Ok "Composer ($ComposerExe)"
} elseif (Test-Path $VendorDir) {
    Warn "Composer no encontrado en el PATH; se usará la carpeta vendor/ existente."
} else {
    Fail "Composer no encontrado y no existe vendor/. Instala Composer (https://getcomposer.org/ o 'winget install Composer') y reintenta."
}

if (-not (Test-Path $XamppPath)) {
    Fail "XAMPP no encontrado en $XamppPath. Usa -XamppPath con la ruta correcta."
}
$MysqlExe = Join-Path $XamppPath "mysql\bin\mysql.exe"
if (-not (Test-Path $MysqlExe)) {
    Fail "mysql.exe no encontrado en $MysqlExe"
}
Ok "XAMPP en $XamppPath"

# ------------------------------------------------------------- 2. services
Step "2/6 Verificando servicios (Apache/MySQL)"

if (Test-Port 3306) {
    Ok "MySQL ya está corriendo (puerto 3306)"
} else {
    Write-Host "    Iniciando XAMPP (Apache + MySQL)..."
    $XamppStart = Join-Path $XamppPath "xampp_start.exe"
    if (Test-Path $XamppStart) {
        Start-Process -FilePath $XamppStart -WindowStyle Hidden
    } else {
        Fail "xampp_start.exe no encontrado en $XamppPath. Inicia MySQL manualmente y reintenta."
    }
    $up = $false
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Seconds 1
        if (Test-Port 3306) { $up = $true; break }
    }
    if (-not $up) {
        Fail "MySQL no respondió en el puerto 3306 tras 30 segundos. Inicia XAMPP manualmente y reintenta."
    }
    Ok "MySQL corriendo (puerto 3306)"
}

# ---------------------------------------------------------- 3. dependencies
Step "3/6 Instalando dependencias (composer)"

if ($ComposerExe) {
    Push-Location $LaravelDir
    try {
        & $ComposerExe install --no-interaction
        if ($LASTEXITCODE -ne 0) { Fail "composer install terminó con errores" }
        Ok "composer install"
    } finally {
        Pop-Location
    }
} else {
    Warn "vendor/ existente: se omite composer install"
}

# ------------------------------------------------------------- 4. env file
Step "4/6 Configurando entorno (.env)"

if (-not (Test-Path $EnvFile)) {
    Copy-Item -LiteralPath $EnvExample -Destination $EnvFile
    Ok ".env creado desde .env.example"
} else {
    Ok ".env ya existe: se conserva"
}

$envMap = Read-EnvFile $EnvFile
if ([string]::IsNullOrWhiteSpace($envMap["APP_KEY"])) {
    & $PhpExe (Join-Path $LaravelDir "artisan") key:generate --force
    if ($LASTEXITCODE -ne 0) { Fail "php artisan key:generate terminó con errores" }
    Ok "APP_KEY generada"
} else {
    Ok "APP_KEY ya presente"
}

# ------------------------------------------------------------- 5. database
Step "5/6 Importando base de datos (gaud, datos demo)"

$mysqlArgs = @("-u", "root")
if ($DbPassword) { $mysqlArgs += "-p$DbPassword" }
$cmdLine = "`"$MysqlExe`" $($mysqlArgs -join ' ') < `"$SqlFile`""
& cmd.exe /c $cmdLine
if ($LASTEXITCODE -ne 0) {
    Fail "La importación de gaud.sql falló. Verifica que MySQL esté corriendo y la credencial (-DbPassword)."
}
Ok "gaud.sql importado (BD gaud recreada con datos demo)"

# ------------------------------------------------------------ 6. verify
Step "6/6 Verificando instalación"

$envMap = Read-EnvFile $EnvFile
$dbHost = $envMap["DB_HOST"]; if (-not $dbHost) { $dbHost = "127.0.0.1" }
$dbPort = $envMap["DB_PORT"]; if (-not $dbPort) { $dbPort = "3306" }
$dbName = $envMap["DB_DATABASE"]
$dbUser = $envMap["DB_USERNAME"]
$dbPass = $envMap["DB_PASSWORD"]

$phpCode = "try { new PDO('mysql:host=$dbHost;port=$dbPort;dbname=$dbName', '$dbUser', '$dbPass'); echo 'OK'; } catch (Exception `$e) { fwrite(STDERR, `$e->getMessage()); exit(1); }"
& $PhpExe -r $phpCode
if ($LASTEXITCODE -ne 0) {
    Fail "No se pudo conectar a la base de datos $dbName"
}
Ok "Conexión BD OK ($dbName)"

# ------------------------------------------------------------------- serve
if ($Serve) {
    $port = 8000
    if (Test-Port $port) {
        $port = 8080
        if (Test-Port $port) {
            Fail "Los puertos 8000 y 8080 están ocupados. Libera uno y reintenta con -Serve."
        }
    }
    Write-Host "    Servidor en http://127.0.0.1:$port (Ctrl+C para detener)" -ForegroundColor Cyan
    Start-Process "http://127.0.0.1:$port"
    & $PhpExe (Join-Path $LaravelDir "artisan") serve --host=127.0.0.1 --port=$port
}

Write-Host "`nSetup completado." -ForegroundColor Green
Write-Host "  Para ejecutar:  cd laravel && php artisan serve"
Write-Host "  URL:            http://127.0.0.1:8000"
Write-Host "  Usuario demo:   estudiante@gaud.dev / Gaud2026!"
