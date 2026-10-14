<?php
require_once __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    fail('Método no permitido', 405);
}

$universidades = db()->query(
    'SELECT id, nombre FROM universidades ORDER BY nombre'
)->fetchAll();

$carreras = db()->query(
    'SELECT id, universidad_id, nombre FROM carreras ORDER BY nombre'
)->fetchAll();

$mapa = [];
foreach ($carreras as $c) {
    $mapa[$c['universidad_id']][] = ['id' => (int) $c['id'], 'nombre' => $c['nombre']];
}

$resultado = array_map(fn($u) => [
    'id' => (int) $u['id'],
    'nombre' => $u['nombre'],
    'carreras' => $mapa[$u['id']] ?? [],
], $universidades);

ok(['universidades' => $resultado]);
