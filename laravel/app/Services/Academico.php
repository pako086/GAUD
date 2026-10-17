<?php

namespace App\Services;

use App\Models\Asignatura;
use Illuminate\Support\Facades\DB;

class Academico
{
    /**
     * Bloqueos individuales para inscribir/aprobar una asignatura según prerrequisitos y correquisitos.
     *
     * $inscPorAsignaturaId: mapa asignatura_id => ['estado' => ?string, 'calificacion' => ?string]
     * $estadoDestino: 'en-curso' | 'aprobada' | 'pendiente'
     *
     * Reglas:
     * - Prerrequisito: debe estar 'aprobada'.
     * - Correquisito (se cursan siempre juntas):
     *   - destino 'en-curso': el socio debe estar en {pendiente, en-curso}.
     *   - destino 'aprobada': el socio debe estar en {en-curso, aprobada}.
     *   - destino 'pendiente': sin bloqueos (la cascada la maneja el cliente).
     *
     * Para transiciones de grupo completo de correquisitos, usar bloqueosGrupo().
     *
     * Devuelve lista de violaciones: ['tipo' => 'prerrequisito'|'correquisito', 'codigo' => string, 'nombre' => string]
     */
    public function bloqueosInscripcion(Asignatura $asignatura, array $inscPorAsignaturaId, string $estadoDestino): array
    {
        if ($estadoDestino === 'pendiente') {
            return [];
        }

        $bloqueos = [];

        foreach ($asignatura->prerrequisitos as $rel) {
            $estado = $inscPorAsignaturaId[$rel->id]['estado'] ?? null;
            if ($estado !== 'aprobada') {
                $bloqueos[] = ['tipo' => 'prerrequisito', 'codigo' => $rel->codigo, 'nombre' => $rel->nombre];
            }
        }

        foreach ($asignatura->correquisitos as $rel) {
            $estadoSocio = $inscPorAsignaturaId[$rel->id]['estado'] ?? 'pendiente';
            $permitidos = $estadoDestino === 'aprobada'
                ? ['en-curso', 'aprobada']
                : ['pendiente', 'en-curso'];
            if (! in_array($estadoSocio, $permitidos, true)) {
                $bloqueos[] = ['tipo' => 'correquisito', 'codigo' => $rel->codigo, 'nombre' => $rel->nombre];
            }
        }

        return $bloqueos;
    }

    public function grupoCorrequisitos(Asignatura $asignatura): array
    {
        $ids = [(int) $asignatura->id];
        $vistos = [(int) $asignatura->id => true];
        $cola = [(int) $asignatura->id];

        while ($cola) {
            $actual = array_pop($cola);

            $relaciones = DB::table('asignatura_relaciones')
                ->where('tipo', 'correquisito')
                ->where(function ($q) use ($actual) {
                    $q->where('asignatura_id', $actual)->orWhere('relacionada_id', $actual);
                })
                ->get();

            foreach ($relaciones as $rel) {
                $asignaturaId = (int) $rel->asignatura_id;
                $relacionadaId = (int) $rel->relacionada_id;
                $otroId = $asignaturaId === $actual ? $relacionadaId : $asignaturaId;

                if (isset($vistos[$otroId])) {
                    continue;
                }

                $existe = Asignatura::where('id', $otroId)
                    ->where('carrera_id', $asignatura->carrera_id)
                    ->exists();

                if (! $existe) {
                    continue;
                }

                $vistos[$otroId] = true;
                $ids[] = $otroId;
                $cola[] = $otroId;
            }
        }

        return Asignatura::whereIn('id', $ids)
            ->orderBy('periodo')
            ->orderBy('id')
            ->get()
            ->all();
    }

    /**
     * Evalúa los bloqueos de un grupo completo de correquisitos.
     *
     * Todos los miembros del grupo se consideran en $estadoDestino antes de validar prerrequisitos y correquisitos.
     * Esto permite transiciones como 'aprobada' => 'en-curso' cuando los prerrequisitos del grupo están aprobados.
     */
    public function bloqueosGrupo(array $grupo, array $inscPorAsignaturaId, string $estadoDestino): array
    {
        if ($estadoDestino === 'pendiente') {
            return [];
        }

        $efectivo = $inscPorAsignaturaId;
        foreach ($grupo as $a) {
            $efectivo[$a->id] = [
                'estado' => $estadoDestino,
                'calificacion' => $inscPorAsignaturaId[$a->id]['calificacion'] ?? null,
            ];
        }

        $bloqueos = [];
        $vistos = [];
        foreach ($grupo as $a) {
            foreach ($this->bloqueosInscripcion($a, $efectivo, $estadoDestino) as $b) {
                $clave = $b['tipo'] . '|' . $b['codigo'];
                if (isset($vistos[$clave])) {
                    continue;
                }
                $vistos[$clave] = true;
                $bloqueos[] = $b;
            }
        }

        return $bloqueos;
    }

    public function invalidarDependientesPrerrequisito(array $asignaturasCambiadas, array &$inscPorId, int $usuarioId): array
    {
        $afectados = [];
        $afectadosIds = [];
        $vistos = [];
        $cola = [];

        foreach ($asignaturasCambiadas as $asignatura) {
            $id = (int) $asignatura->id;
            if (! isset($vistos[$id])) {
                $vistos[$id] = true;
                $cola[] = $id;
            }
        }

        while ($cola) {
            $id = array_pop($cola);

            $dependientes = DB::table('asignatura_relaciones')
                ->where('tipo', 'prerrequisito')
                ->where('relacionada_id', $id)
                ->pluck('asignatura_id')
                ->map(fn ($value) => (int) $value)
                ->all();

            foreach ($dependientes as $dependienteId) {
                $dependiente = Asignatura::find($dependienteId);
                if (! $dependiente) {
                    continue;
                }

                $grupo = $this->grupoCorrequisitos($dependiente);

                $hayActivo = false;
                foreach ($grupo as $miembro) {
                    $estado = $inscPorId[$miembro->id]['estado'] ?? 'pendiente';
                    if (in_array($estado, ['en-curso', 'aprobada'], true)) {
                        $hayActivo = true;
                        break;
                    }
                }

                if ($hayActivo) {
                    foreach ($grupo as $miembro) {
                        $miembroId = (int) $miembro->id;
                        $estado = $inscPorId[$miembroId]['estado'] ?? 'pendiente';
                        if (! in_array($estado, ['en-curso', 'aprobada'], true) || isset($afectadosIds[$miembroId])) {
                            continue;
                        }

                        DB::table('inscripciones')
                            ->where('usuario_id', $usuarioId)
                            ->where('asignatura_id', $miembroId)
                            ->delete();

                        $inscPorId[$miembroId] = ['estado' => 'pendiente', 'calificacion' => null];
                        $afectadosIds[$miembroId] = true;
                        $afectados[] = [
                            'id' => $miembroId,
                            'codigo' => $miembro->codigo,
                            'nombre' => $miembro->nombre,
                            'estado' => 'pendiente',
                            'calificacion' => null,
                        ];
                    }
                }

                foreach ($grupo as $miembro) {
                    $miembroId = (int) $miembro->id;
                    if (! isset($vistos[$miembroId])) {
                        $vistos[$miembroId] = true;
                        $cola[] = $miembroId;
                    }
                }
            }
        }

        return $afectados;
    }

    public function calificacionMiembroGrupo(
        ?array $inscripcion,
        string $estadoDestino,
        ?string $calificacionPrincipal,
        bool $esPrincipal
    ): ?string {
        if ($estadoDestino !== 'aprobada') {
            return null;
        }

        if ($esPrincipal) {
            return $calificacionPrincipal;
        }

        $estado = $inscripcion['estado'] ?? null;
        $calificacion = $inscripcion['calificacion'] ?? null;

        if ($estado === 'aprobada' && $calificacion !== null) {
            $calificacion = strtoupper((string) $calificacion);
            if (in_array($calificacion, ['A', 'B', 'C'], true)) {
                return $calificacion;
            }
        }

        return null;
    }

    public function describirBloqueos(array $bloqueos): string
    {
        $partes = [];
        foreach ($bloqueos as $b) {
            $tipo = $b['tipo'] === 'prerrequisito' ? 'Prerrequisito' : 'Correquisito';
            $partes[] = "{$tipo} no cumplido: {$b['codigo']} {$b['nombre']}";
        }

        return implode('; ', $partes);
    }

    /**
     * Devuelve el periodo actual según las inscripciones del usuario.
     * - Si hay "en-curso": el mayor periodo entre ellas.
     * - Si solo hay "aprobadas": max(periodo aprobados) + 1 (máx. 16).
     * - Si no hay inscripciones: 1.
     *
     * Cada elemento: ['periodo' => int, 'creditos' => int, 'estado' => ?string, 'calificacion' => ?string]
     */
    public function calcularPeriodo(array $inscripciones): int
    {
        $enCurso = array_filter($inscripciones, fn ($i) => ($i['estado'] ?? null) === 'en-curso');
        if (! empty($enCurso)) {
            return (int) max(array_map(fn ($i) => (int) $i['periodo'], $enCurso));
        }

        $aprobadas = array_filter($inscripciones, fn ($i) => ($i['estado'] ?? null) === 'aprobada');
        if (! empty($aprobadas)) {
            $maxPeriodo = max(array_map(fn ($i) => (int) $i['periodo'], $aprobadas));

            return min($maxPeriodo + 1, 16);
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
     * Cada elemento: ['periodo' => int, 'creditos' => int, 'estado' => ?string, 'calificacion' => ?string]
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
