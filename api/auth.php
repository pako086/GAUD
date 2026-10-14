<?php
require_once __DIR__ . '/config.php';

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

if ($action === 'logout' && $method === 'POST') {
    session_destroy();
    ok(['mensaje' => 'Sesión cerrada']);
}

if ($method === 'GET') {
    $user = require_auth();
    $stmt = db()->prepare(
        'SELECT a.trimestre, i.estado
         FROM inscripciones i
         JOIN asignaturas a ON a.id = i.asignatura_id
         WHERE i.usuario_id = ?'
    );
    $stmt->execute([$user['id']]);
    $inscripciones = $stmt->fetchAll();
    $user['trimestre_actual'] = calcular_trimestre($inscripciones);
    ok($user);
}

if ($method === 'POST' && $action === '') {
    $input = input_json();
    $email = trim($input['email'] ?? '');
    $password = $input['password'] ?? '';

    if ($email === '' || $password === '') {
        fail('Email y contraseña son obligatorios');
    }

    $stmt = db()->prepare('SELECT id, password_hash FROM usuarios WHERE email = ?');
    $stmt->execute([$email]);
    $row = $stmt->fetch();

    if (!$row || !password_verify($password, $row['password_hash'])) {
        fail('Credenciales incorrectas', 401);
    }

    session_regenerate_id(true);
    $_SESSION['usuario_id'] = (int) $row['id'];

    $stmt = db()->prepare(
        'SELECT u.id, u.nombre, u.email, u.telefono, u.direccion,
                un.nombre AS universidad, c.nombre AS carrera,
                u.universidad_id, u.carrera_id, u.modalidad, u.terminos_aceptado_en, u.creado_en
         FROM usuarios u
         JOIN universidades un ON un.id = u.universidad_id
         JOIN carreras c ON c.id = u.carrera_id
         WHERE u.id = ?'
    );
    $stmt->execute([$row['id']]);
    $user = $stmt->fetch();

    $stmt = db()->prepare(
        'SELECT a.trimestre, i.estado
         FROM inscripciones i
         JOIN asignaturas a ON a.id = i.asignatura_id
         WHERE i.usuario_id = ?'
    );
    $stmt->execute([$row['id']]);
    $inscripciones = $stmt->fetchAll();
    $user['trimestre_actual'] = calcular_trimestre($inscripciones);

    ok($user, 201);
}

fail('Método no permitido', 405);
