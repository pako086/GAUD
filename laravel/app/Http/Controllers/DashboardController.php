<?php

namespace App\Http\Controllers;

use App\Models\Asignatura;
use App\Models\Inscripcion;
use App\Services\Academico;
use Illuminate\Support\Facades\Auth;

class DashboardController extends Controller
{
    public function __construct(protected Academico $academico)
    {
    }

    /**
     * GET /api/dashboard.php -> resumen académico del usuario autenticado.
     */
    public function index()
    {
        $user = Auth::user();

        $asignaturas = Asignatura::where('carrera_id', $user->carrera_id)
            ->orderBy('periodo')
            ->orderBy('id')
            ->get();

        $inscripciones = Inscripcion::where('usuario_id', $user->id)
            ->get()
            ->keyBy('asignatura_id');

        $asignaturaPorId = $asignaturas->keyBy('id');

        $poolPorPeriodo = [];
        foreach ($inscripciones as $i) {
            $a = $asignaturaPorId->get($i->asignatura_id);
            if ($a && (int) $a->periodo === 0) {
                $poolPorPeriodo[(int) $i->periodo] = ['asignatura' => $a, 'inscripcion' => $i];
            }
        }

        $total = 0;
        $aprobadas = 0;
        $enCurso = 0;
        $pendientes = 0;
        $totalCreditos = 0;
        $creditosGanados = 0;
        $distribucion = ['A' => 0, 'B' => 0, 'C' => 0];
        $inscripcionesData = [];

        foreach ($asignaturas as $a) {
            if ((int) $a->periodo === 0) {
                continue;
            }

            $insc = $inscripciones->get($a->id);
            $estado = $insc?->estado ?? 'pendiente';
            $calificacion = $insc?->calificacion;
            $creditos = (int) $a->creditos;
            $periodo = (int) $a->periodo;

            if ($insc === null && $a->tipo === 'optativa' && isset($poolPorPeriodo[$periodo])) {
                $fill = $poolPorPeriodo[$periodo];
                $estado = $fill['inscripcion']->estado;
                $calificacion = $fill['inscripcion']->calificacion;
                $creditos = (int) $fill['asignatura']->creditos;
                $periodo = (int) $fill['inscripcion']->periodo;
            }

            $total++;
            $totalCreditos += $creditos;

            if ($estado === 'aprobada') {
                $aprobadas++;
                $creditosGanados += $creditos;
            } elseif ($estado === 'en-curso') {
                $enCurso++;
            } else {
                $pendientes++;
            }

            if (in_array($calificacion, ['A', 'B', 'C'], true)) {
                $distribucion[$calificacion]++;
            }

            $inscripcionesData[] = [
                'periodo' => $periodo,
                'creditos' => $creditos,
                'estado' => $estado,
                'calificacion' => $calificacion,
            ];
        }

        $progreso = $totalCreditos > 0 ? round(($creditosGanados / $totalCreditos) * 100, 1) : 0;

        return $this->ok([
            'total_asignaturas' => $total,
            'aprobadas' => $aprobadas,
            'en_curso' => $enCurso,
            'pendientes' => $pendientes,
            'total_creditos' => $totalCreditos,
            'creditos_ganados' => $creditosGanados,
            'progreso' => $progreso,
            'periodo_actual' => $this->academico->calcularPeriodo($inscripcionesData),
            'indice_academico' => $this->academico->calcularIndiceAcademico($inscripcionesData),
            'distribucion' => $distribucion,
        ]);
    }
}
