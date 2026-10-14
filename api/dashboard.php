<?php
require_once __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    fail('Método no permitido', 405);
}

$user = require_auth();

$stmt = db()->prepare(
    'SELECT a.id, a.codigo, a.nombre, a.creditos, a.trimestre,
            i.estado AS inscrito_estado, i.calificacion
     FROM asignaturas a
     LEFT JOIN inscripciones i ON i.asignatura_id = a.id AND i.usuario_id = ?
     WHERE a.carrera_id = ?
     ORDER BY a.trimestre, a.id'
);
$stmt->execute([$user['id'], $user['carrera_id']]);
$asignaturas = $stmt->fetchAll();

$total = count($asignaturas);
$aprobadas = 0;
$en_curso = 0;
$pendientes = 0;
$total_creditos = 0;
$creditos_ganados = 0;
$distribucion = ['A' => 0, 'B' => 0, 'C' => 0];

foreach ($asignaturas as $a) {
    $total_creditos += $a['creditos'];
    $estado = $a['inscrito_estado'] ?? 'pendiente';
    if ($estado === 'aprobada') {
        $aprobadas++;
        $creditos_ganados += $a['creditos'];
    } elseif ($estado === 'en-curso') {
        $en_curso++;
    } else {
        $pendientes++;
    }

    $cal = $a['calificacion'];
    if ($cal === 'A' || $cal === 'B' || $cal === 'C') {
        $distribucion[$cal]++;
    }
}

$progreso = $total_creditos > 0 ? round(($creditos_ganados / $total_creditos) * 100, 1) : 0;

$inscripciones = array_map(fn($a) => [
    'trimestre' => $a['trimestre'],
    'creditos' => $a['creditos'],
    'estado' => $a['inscrito_estado'] ?? 'pendiente',
    'calificacion' => $a['calificacion'],
], $asignaturas);

$trimestre_actual = calcular_trimestre($inscripciones);
$indice_academico = calcular_indice_academico($inscripciones);

ok([
    'total_asignaturas' => $total,
    'aprobadas' => $aprobadas,
    'en_curso' => $en_curso,
    'pendientes' => $pendientes,
    'total_creditos' => $total_creditos,
    'creditos_ganados' => $creditos_ganados,
    'progreso' => $progreso,
    'trimestre_actual' => $trimestre_actual,
    'indice_academico' => $indice_academico,
    'distribucion' => $distribucion,
]);
