<?php
require_once __DIR__ . '/config.php';

function carrera_pertenece_a_universidad(int $universidad_id, int $carrera_id): bool {
    $stmt = db()->prepare(
        'SELECT c.id FROM carreras c
         JOIN universidades un ON un.id = c.universidad_id
         WHERE c.id = ? AND un.id = ?'
    );
    $stmt->execute([$carrera_id, $universidad_id]);
    return (bool) $stmt->fetch();
}

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

if ($method === 'POST' && $action === '') {
    $input = input_json();

    $nombre = trim($input['nombre'] ?? '');
    $email = trim($input['email'] ?? '');
    $password = $input['password'] ?? '';
    $telefono = trim($input['telefono'] ?? '') ?: null;
    $direccion = trim($input['direccion'] ?? '') ?: null;
    $universidad_id = (int) ($input['universidad_id'] ?? 0);
    $carrera_id = (int) ($input['carrera_id'] ?? 0);
    $modalidad = $input['modalidad'] ?? '';
    $terminos = $input['terminos_aceptados'] ?? false;

    if ($nombre === '' || $email === '' || $password === '' || $universidad_id <= 0 || $carrera_id <= 0 || $modalidad === '') {
        fail('Nombre, email, contraseña, universidad, carrera y modalidad son obligatorios');
    }
    if (strlen($password) < 8) {
        fail('La contraseña debe tener al menos 8 caracteres');
    }
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        fail('Email inválido');
    }
    if (!in_array($modalidad, ['presencial', 'virtual', 'mixta'])) {
        fail('Modalidad inválida');
    }
    if (!$terminos) {
        fail('Debes aceptar los términos y condiciones');
    }
    if (!carrera_pertenece_a_universidad($universidad_id, $carrera_id)) {
        fail('La carrera no pertenece a la universidad seleccionada');
    }

    $stmt = db()->prepare('SELECT id FROM usuarios WHERE email = ?');
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        fail('Este email ya está registrado', 409);
    }

    $hash = password_hash($password, PASSWORD_DEFAULT);
    $stmt = db()->prepare(
        'INSERT INTO usuarios (nombre, email, password_hash, telefono, direccion, universidad_id, carrera_id, modalidad, terminos_aceptado_en)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())'
    );
    $stmt->execute([$nombre, $email, $hash, $telefono, $direccion, $universidad_id, $carrera_id, $modalidad]);
    $id = (int) db()->lastInsertId();

    session_regenerate_id(true);
    $_SESSION['usuario_id'] = $id;

    ok(['id' => $id, 'mensaje' => 'Cuenta creada'], 201);
}

if ($method === 'GET' && $action === '') {
    $user = require_auth();
    ok($user);
}

if ($method === 'PUT' && $action === '') {
    $user = require_auth();
    $input = input_json();

    $nombre = trim($input['nombre'] ?? '');
    $email = isset($input['email']) ? trim($input['email']) : null;
    $telefono = trim($input['telefono'] ?? '') ?: null;
    $direccion = trim($input['direccion'] ?? '') ?: null;
    $universidad_id = (int) ($input['universidad_id'] ?? 0);
    $carrera_id = (int) ($input['carrera_id'] ?? 0);
    $modalidad = $input['modalidad'] ?? '';

    if ($nombre === '' || $universidad_id <= 0 || $carrera_id <= 0 || $modalidad === '') {
        fail('Nombre, universidad, carrera y modalidad son obligatorios');
    }
    if (!in_array($modalidad, ['presencial', 'virtual', 'mixta'])) {
        fail('Modalidad inválida');
    }
    if (!carrera_pertenece_a_universidad($universidad_id, $carrera_id)) {
        fail('La carrera no pertenece a la universidad seleccionada');
    }
    if ($email !== null) {
        if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            fail('Email inválido');
        }
        $stmt = db()->prepare('SELECT id FROM usuarios WHERE email = ? AND id <> ?');
        $stmt->execute([$email, $user['id']]);
        if ($stmt->fetch()) {
            fail('Este email ya está registrado', 409);
        }
    }

    $stmt = db()->prepare(
        'UPDATE usuarios SET nombre = ?, email = ?, telefono = ?, direccion = ?, universidad_id = ?, carrera_id = ?, modalidad = ? WHERE id = ?'
    );
    $stmt->execute([$nombre, $email ?? $user['email'], $telefono, $direccion, $universidad_id, $carrera_id, $modalidad, $user['id']]);

    ok(['mensaje' => 'Perfil actualizado']);
}

if ($method === 'PUT' && $action === 'password') {
    $user = require_auth();
    $input = input_json();

    $actual = $input['password_actual'] ?? '';
    $nueva = $input['password_nueva'] ?? '';
    $confirmar = $input['password_confirmar'] ?? '';

    if ($actual === '' || $nueva === '' || $confirmar === '') {
        fail('Debes ingresar la contraseña actual, la nueva y la confirmación');
    }
    if (strlen($nueva) < 8) {
        fail('La nueva contraseña debe tener al menos 8 caracteres');
    }
    if ($nueva !== $confirmar) {
        fail('La contraseña nueva y la confirmación no coinciden');
    }

    $stmt = db()->prepare('SELECT password_hash FROM usuarios WHERE id = ?');
    $stmt->execute([$user['id']]);
    $row = $stmt->fetch();

    if (!password_verify($actual, $row['password_hash'])) {
        fail('La contraseña actual es incorrecta');
    }

    $hash = password_hash($nueva, PASSWORD_DEFAULT);
    $stmt = db()->prepare('UPDATE usuarios SET password_hash = ? WHERE id = ?');
    $stmt->execute([$hash, $user['id']]);

    ok(['mensaje' => 'Contraseña actualizada']);
}

if ($method === 'DELETE' && $action === '') {
    $user = require_auth();
    $stmt = db()->prepare('DELETE FROM usuarios WHERE id = ?');
    $stmt->execute([$user['id']]);
    session_destroy();
    ok(['mensaje' => 'Cuenta eliminada']);
}

fail('Método no permitido', 405);
