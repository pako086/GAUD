<?php
require_once __DIR__ . '/config.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $user = require_auth();

    $stmt = db()->prepare(
        'SELECT a.id, a.codigo, a.nombre, a.creditos, a.trimestre,
                i.estado AS inscrito_estado, i.calificacion
         FROM asignaturas a
         LEFT JOIN inscripciones i ON i.asignatura_id = a.id AND i.usuario_id = ?
         ORDER BY a.trimestre, a.id'
    );
    $stmt->execute([$user['id']]);
    $asignaturas = $stmt->fetchAll();

    foreach ($asignaturas as &$a) {
        $a['id'] = (int) $a['id'];
        $a['creditos'] = (int) $a['creditos'];
        $a['trimestre'] = (int) $a['trimestre'];
        $a['calificacion'] = $a['calificacion'] !== null ? strtoupper($a['calificacion']) : null;
        $a['estado'] = $a['inscrito_estado'] ?? 'pendiente';
        unset($a['inscrito_estado']);
    }

    ok($asignaturas);
}

if ($method === 'PUT') {
    $user = require_auth();
    $input = input_json();
    $id = (int) ($input['id'] ?? 0);
    $nuevo_estado = $input['estado'] ?? '';
    $calificacion = $input['calificacion'] ?? null;

    if ($id <= 0) {
        fail('ID de asignatura inválido');
    }
    if (!in_array($nuevo_estado, ['pendiente', 'en-curso', 'aprobada'])) {
        fail('Estado inválido');
    }

    $stmt = db()->prepare('SELECT id FROM asignaturas WHERE id = ?');
    $stmt->execute([$id]);
    if (!$stmt->fetch()) {
        fail('Asignatura no encontrada', 404);
    }

    if ($calificacion !== null) {
        $calificacion = strtoupper(trim((string) $calificacion));
        if (!in_array($calificacion, ['A', 'B', 'C'], true)) {
            fail('Calificación inválida: debe ser A, B o C');
        }
    }

    if ($nuevo_estado === 'pendiente') {
        $stmt = db()->prepare('DELETE FROM inscripciones WHERE usuario_id = ? AND asignatura_id = ?');
        $stmt->execute([$user['id'], $id]);
    } else {
        if ($nuevo_estado !== 'aprobada') {
            $calificacion = null;
        }

        $stmt = db()->prepare(
            'INSERT INTO inscripciones (usuario_id, asignatura_id, estado, calificacion)
             VALUES (?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE estado = VALUES(estado), calificacion = VALUES(calificacion)'
        );
        $stmt->execute([$user['id'], $id, $nuevo_estado, $calificacion]);
    }

    ok(['mensaje' => 'Estado actualizado', 'id' => $id, 'estado' => $nuevo_estado]);
}

fail('Método no permitido', 405);
