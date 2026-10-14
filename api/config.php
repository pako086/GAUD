<?php
declare(strict_types=1);

session_start();

define('DB_HOST', '127.0.0.1');
define('DB_NAME', 'gaud');
define('DB_USER', 'root');
define('DB_PASS', '');

function db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
            DB_USER,
            DB_PASS,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ]
        );
    }
    return $pdo;
}

function json_response(array $data, int $code = 200): void
{
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function ok(array $data, int $code = 200): void
{
    json_response(['ok' => true, 'data' => $data], $code);
}

function fail(string $error, int $code = 400): void
{
    json_response(['ok' => false, 'error' => $error], $code);
}

function require_auth(): array
{
    if (empty($_SESSION['usuario_id'])) {
        fail('No autenticado', 401);
    }
    $stmt = db()->prepare(
        'SELECT u.id, u.nombre, u.email, u.telefono, u.direccion,
                un.nombre AS universidad, c.nombre AS carrera,
                u.universidad_id, u.carrera_id, u.modalidad, u.terminos_aceptado_en, u.creado_en
         FROM usuarios u
         JOIN universidades un ON un.id = u.universidad_id
         JOIN carreras c ON c.id = u.carrera_id
         WHERE u.id = ?'
    );
    $stmt->execute([$_SESSION['usuario_id']]);
    $user = $stmt->fetch();
    if (!$user) {
        session_destroy();
        fail('No autenticado', 401);
    }
    return $user;
}

function input_json(): array
{
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

function calcular_trimestre(array $inscripciones): int
{
    $en_curso = array_filter($inscripciones, fn($i) => $i['estado'] === 'en-curso');
    if (!empty($en_curso)) {
        return (int) max(array_column($en_curso, 'trimestre'));
    }
    $aprobadas = array_filter($inscripciones, fn($i) => $i['estado'] === 'aprobada');
    if (!empty($aprobadas)) {
        return min((int) max(array_column($aprobadas, 'trimestre')) + 1, 16);
    }
    return 1;
}

function puntos_por_calificacion(string $letra): ?float
{
    $mapa = ['A' => 4.0, 'B' => 3.0, 'C' => 2.0];
    return $mapa[$letra] ?? null;
}

function calcular_indice_academico(array $inscripciones): float
{
    $sum_puntos = 0.0;
    $sum_creditos = 0;
    foreach ($inscripciones as $i) {
        if ($i['estado'] !== 'aprobada' || $i['calificacion'] === null) {
            continue;
        }
        $puntos = puntos_por_calificacion($i['calificacion']);
        if ($puntos === null) {
            continue;
        }
        $creditos = (int) $i['creditos'];
        $sum_puntos += $puntos * $creditos;
        $sum_creditos += $creditos;
    }
    if ($sum_creditos === 0) {
        return 0.00;
    }
    return round($sum_puntos / $sum_creditos, 2);
}
