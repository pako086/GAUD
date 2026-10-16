<?php

namespace App\Services;

use App\Models\Inscripcion;

class Academico
{
    /**
     * Devuelve el trimestre actual según las inscripciones del usuario.
     * - Si hay "en-curso": el mayor trimestre entre ellas.
     * - Si solo hay "aprobadas": max(trimestre aprobados) + 1 (máx. 16).
     * - Si no hay inscripciones: 1.
     *
     * Inscripciones (con relación asignatura cargada)
     */
    @param Inscripcion[]
    public function calcularTrimestre(array $inscripciones): int
    {
        $enCurso = array_filter($inscripciones, fn (Inscripcion $i) => $i->estado === 'en-curso');
        if (! empty($enCurso)) {
            return (int) max(array_map(fn (Inscripcion $i) => (int) $i->asignatura->trimestre, $enCurso));
        }

        $aprobadas = array_filter($inscripciones, fn (Inscripcion $i) => $i->estado === 'aprobada');
        if (! empty($aprobadas)) {
            $maxTrimestre = max(array_map(fn (Inscripcion $i) => (int) $i->asignatura->trimestre, $aprobadas));

            return min($maxTrimestre + 1, 16);
        }

        return 1;
    }

    public function puntosPorCalificacion(string $letra): ?float
    {
        $mapa = ['A' => 4.0, 'B' => 3.0, 'C' => 2.0];

        return $mapa[$letra] ?? null;
    }

    /**
     * Índice académico (0-4) ponderado por créditos, sobre inscripciones aprobadas.
     *
     * @param Inscripcion[] $inscripciones (con relación asignatura cargada)
     */
    public function calcularIndiceAcademico(array $inscripciones): float
    {
        $sumPuntos = 0.0;
        $sumCreditos = 0;

        foreach ($inscripciones as $i) {
            if ($i->estado !== 'aprobada' || $i->calificacion === null) {
                continue;
            }

            $puntos = $this->puntosPorCalificacion($i->calificacion);
            if ($puntos === null) {
                continue;
            }

            $creditos = (int) $i->asignatura->creditos;
            $sumPuntos += $puntos * $creditos;
            $sumCreditos += $creditos;
        }

        if ($sumCreditos === 0) {
            return 0.0;
        }

        return round($sumPuntos / $sumCreditos, 2);
    }
}
