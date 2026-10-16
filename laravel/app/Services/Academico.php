<?php

namespace App\Services;

class Academico
{
    /**
     * Devuelve el trimestre actual según las inscripciones del usuario.
     * - Si hay "en-curso": el mayor trimestre entre ellas.
     * - Si solo hay "aprobadas": max(trimestre aprobados) + 1 (máx. 16).
     * - Si no hay inscripciones: 1.
     *
     * Cada elemento: ['trimestre' => int, 'creditos' => int, 'estado' => ?string, 'calificacion' => ?string]
     */
    public function calcularTrimestre(array $inscripciones): int
    {
        $enCurso = array_filter($inscripciones, fn ($i) => ($i['estado'] ?? null) === 'en-curso');
        if (! empty($enCurso)) {
            return (int) max(array_map(fn ($i) => (int) $i['trimestre'], $enCurso));
        }

        $aprobadas = array_filter($inscripciones, fn ($i) => ($i['estado'] ?? null) === 'aprobada');
        if (! empty($aprobadas)) {
            $maxTrimestre = max(array_map(fn ($i) => (int) $i['trimestre'], $aprobadas));

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
     * Cada elemento: ['trimestre' => int, 'creditos' => int, 'estado' => ?string, 'calificacion' => ?string]
     */
    public function calcularIndiceAcademico(array $inscripciones): float
    {
        $sumPuntos = 0.0;
        $sumCreditos = 0;

        foreach ($inscripciones as $i) {
            if (($i['estado'] ?? null) !== 'aprobada' || ($i['calificacion'] ?? null) === null) {
                continue;
            }

            $puntos = $this->puntosPorCalificacion((string) $i['calificacion']);
            if ($puntos === null) {
                continue;
            }

            $creditos = (int) ($i['creditos'] ?? 0);
            $sumPuntos += $puntos * $creditos;
            $sumCreditos += $creditos;
        }

        if ($sumCreditos === 0) {
            return 0.0;
        }

        return round($sumPuntos / $sumCreditos, 2);
    }
}
