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
     * GET /api/dashboard.php → resumen académico del usuario autenticado.
     */
    public function index()
    {
        $user = Auth::user();

        $asignaturas = Asignatura::where('carrera_id', $user->carrera_id)
            ->orderBy('trimestre')
            ->orderBy('id')
            ->get();

        $inscripciones = Inscripcion::where('usuario_id', $user->id)
            ->get()
            ->keyBy('asignatura_id');

        $total = $asignaturas->count();
        $aprobadas = 0;
        $enCurso = 0;
        $pendientes = 0;
        $totalCreditos = 0;
        $creditosGanados = 0;
        $distribucion = ['A' => 0, 'B' => 0, 'C' => 0];
        $inscripcionesData = [];

        foreach ($asignaturas as $a) {
            $totalCreditos += $a->creditos;

            $insc = $inscripciones->get($a->id);
            $estado = $insc?->estado ?? 'pendiente';
            $calificacion = $insc?->calificacion;

            if ($estado === 'aprobada') {
                $aprobadas++;
                $creditosGanados += $a->creditos;
            } elseif ($estado === 'en-curso') {
                $enCurso++;
            } else {
                $pendientes++;
            }

            if (in_array($calificacion, ['A', 'B', 'C'], true)) {
                $distribucion[$calificacion]++;
            }

            $inscripcionesData[] = [
                'trimestre' => (int) $a->trimestre,
                'creditos' => (int) $a->creditos,
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
            'trimestre_actual' => $this->academico->calcularTrimestre($inscripcionesData),
            'indice_academico' => $this->academico->calcularIndiceAcademico($inscripcionesData),
            'distribucion' => $distribucion,
        ]);
    }
}
