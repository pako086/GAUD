<?php
require_once __DIR__ . '/config.php';

try {
    $pdo = db();
    $count = $pdo->query('SELECT COUNT(*) FROM asignaturas')->fetchColumn();
    ok(['mensaje' => 'Conexión BD OK', 'asignaturas' => (int) $count]);
} catch (PDOException $e) {
    fail('Error BD: ' . $e->getMessage(), 500);
}
