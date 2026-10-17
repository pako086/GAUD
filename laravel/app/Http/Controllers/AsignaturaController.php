<?php

namespace App\Http\Controllers;

use App\Models\Asignatura;
use App\Models\Inscripcion;
use App\Services\Academico;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class AsignaturaController extends Controller
{
    /**
     * GET /api/asignaturas.php -> todas las asignaturas con el estado de inscripción del usuario.
     */
    public function index()
    {
        $user = Auth::user();
        $academico = new Academico();

        $asignaturas = Asignatura::with(['prerrequisitos', 'correquisitos'])
            ->where('carrera_id', $user->carrera_id)
            ->orderBy('periodo')->orderBy('id')->get();

        $inscripciones = Inscripcion::where('usuario_id', $user->id)
            ->get()
            ->keyBy('asignatura_id');

        $inscPorId = $inscripciones->mapWithKeys(
            fn ($i) => [$i->asignatura_id => ['estado' => $i->estado, 'calificacion' => $i->calificacion]]
        )->all();

        $resultado = $asignaturas->map(function ($a) use ($inscripciones, $inscPorId, $academico) {
            $insc = $inscripciones->get($a->id);
            $estado = $insc?->estado ?? 'pendiente';

            $bloqueos = $academico->bloqueosInscripcion($a, $inscPorId, 'en-curso');

            $companeros = $a->correquisitos->map(function ($c) use ($inscripciones) {
                return [
                    'id' => (int) $c->id,
                    'codigo' => $c->codigo,
                    'nombre' => $c->nombre,
                    'estado' => $inscripciones->get($c->id)?->estado ?? 'pendiente',
                ];
            })->values()->all();

            $prerrequisitos = $a->prerrequisitos->map(function ($r) use ($inscripciones) {
                return [
                    'id' => (int) $r->id,
                    'codigo' => $r->codigo,
                    'nombre' => $r->nombre,
                    'estado' => $inscripciones->get($r->id)?->estado ?? 'pendiente',
                ];
            })->values()->all();

            return [
                'id' => (int) $a->id,
                'codigo' => $a->codigo,
                'nombre' => $a->nombre,
                'creditos' => (int) $a->creditos,
                'periodo' => (int) $a->periodo,
                'tipo' => $a->tipo,
                'calificacion' => $insc?->calificacion !== null ? strtoupper($insc->calificacion) : null,
                'periodo_inscrito' => $insc ? (int) $insc->periodo : null,
                'estado' => $estado,
                'bloqueada' => $estado === 'pendiente' && ! empty($bloqueos),
                'bloqueos' => $bloqueos,
                'prerrequisitos' => $prerrequisitos,
                'companeros' => $companeros,
            ];
        })->all();

        return $this->ok($resultado);
    }

    /**
     * PUT /api/asignaturas.php -> inscribir / actualizar estado de una asignatura.
     */
    public function update(Request $request)
    {
        $user = Auth::user();
        $input = $request->all();

        $id = (int) ($input['id'] ?? 0);
        $nuevoEstado = $input['estado'] ?? '';
        $calificacion = $input['calificacion'] ?? null;
        $periodoInput = $input['periodo'] ?? null;
        $conCorrequisitos = (bool) ($input['con_correquisitos'] ?? false);

        if ($id <= 0) {
            return $this->fail('ID de asignatura inválido');
        }
        if (! in_array($nuevoEstado, ['pendiente', 'en-curso', 'aprobada'], true)) {
            return $this->fail('Estado inválido');
        }

        $asignatura = Asignatura::find($id);
        if (! $asignatura) {
            return $this->fail('Asignatura no encontrada', 404);
        }

        if ((int) $asignatura->carrera_id !== (int) $user->carrera_id) {
            return $this->fail('No autorizado', 403);
        }

        if ($calificacion !== null) {
            $calificacion = strtoupper(trim((string) $calificacion));
            if (! in_array($calificacion, ['A', 'B', 'C'], true)) {
                return $this->fail('Calificación inválida: debe ser A, B o C');
            }
        }

        $periodoInputFinal = null;
        if ($periodoInput !== null && $periodoInput !== '') {
            $p = (int) $periodoInput;
            if ($p < 1 || $p > 16) {
                return $this->fail('Periodo inválido', 422);
            }
            $periodoInputFinal = $p;
        }

        $academico = new Academico();
        $grupo = $conCorrequisitos ? $academico->grupoCorrequisitos($asignatura) : [$asignatura];

        $inscripciones = Inscripcion::where('usuario_id', $user->id)->get();
        $inscPorId = $inscripciones->mapWithKeys(
            fn ($i) => [$i->asignatura_id => ['estado' => $i->estado, 'calificacion' => $i->calificacion]]
        )->all();

        if (in_array($nuevoEstado, ['en-curso', 'aprobada'], true)) {
            $bloqueos = $academico->bloqueosGrupo($grupo, $inscPorId, $nuevoEstado);
            if (! empty($bloqueos)) {
                return $this->fail('No se puede cambiar el estado: ' . $academico->describirBloqueos($bloqueos), 422);
            }
        }

        $resultados = [];
        $afectados = [];

        DB::transaction(function () use (
            $user,
            $grupo,
            $inscripciones,
            $inscPorId,
            $nuevoEstado,
            $calificacion,
            $periodoInputFinal,
            $id,
            $academico,
            &$resultados,
            &$afectados
        ) {
            foreach ($grupo as $a) {
                $insc = $inscripciones->firstWhere('asignatura_id', $a->id);
                $esPrincipal = (int) $a->id === $id;

                if ($nuevoEstado === 'pendiente') {
                    Inscripcion::where('usuario_id', $user->id)
                        ->where('asignatura_id', $a->id)
                        ->delete();
                    $calificacionFinal = null;
                } else {
                    $periodoFinal = $insc ? (int) $insc->periodo : (int) $a->periodo;
                    if ($esPrincipal && $periodoInputFinal !== null) {
                        $periodoFinal = $periodoInputFinal;
                    }

                    $calificacionFinal = $academico->calificacionMiembroGrupo(
                        $inscPorId[$a->id] ?? null,
                        $nuevoEstado,
                        $calificacion,
                        $esPrincipal
                    );

                    if ($nuevoEstado !== 'aprobada') {
                        $calificacionFinal = null;
                    }

                    Inscripcion::updateOrCreate(
                        ['usuario_id' => $user->id, 'asignatura_id' => $a->id],
                        ['periodo' => $periodoFinal, 'estado' => $nuevoEstado, 'calificacion' => $calificacionFinal]
                    );
                }

                $resultados[] = [
                    'id' => (int) $a->id,
                    'codigo' => $a->codigo,
                    'nombre' => $a->nombre,
                    'estado' => $nuevoEstado,
                    'calificacion' => $calificacionFinal,
                ];
            }

            foreach ($resultados as $r) {
                $inscPorId[$r['id']] = [
                    'estado' => $r['estado'],
                    'calificacion' => $r['calificacion'],
                ];
            }

            if ($nuevoEstado !== 'aprobada') {
                $afectados = $academico->invalidarDependientesPrerrequisito(
                    $grupo,
                    $inscPorId,
                    (int) $user->id
                );
            }
        });

        return $this->ok([
            'mensaje' => 'Estado actualizado',
            'id' => $id,
            'estado' => $nuevoEstado,
            'grupo' => $resultados,
            'afectados' => $afectados,
        ]);
    }
}
