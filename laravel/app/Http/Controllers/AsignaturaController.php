<?php

namespace App\Http\Controllers;

use App\Models\Asignatura;
use App\Models\Inscripcion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AsignaturaController extends Controller
{
    /**
     * GET /api/asignaturas.php → todas las asignaturas con el estado de inscripción del usuario.
     */
    public function index()
    {
        $user = Auth::user();

        $asignaturas = Asignatura::orderBy('trimestre')->orderBy('id')->get();

        $inscripciones = Inscripcion::where('usuario_id', $user->id)
            ->get()
            ->keyBy('asignatura_id');

        $resultado = $asignaturas->map(function ($a) use ($inscripciones) {
            $insc = $inscripciones->get($a->id);

            return [
                'id' => (int) $a->id,
                'codigo' => $a->codigo,
                'nombre' => $a->nombre,
                'creditos' => (int) $a->creditos,
                'trimestre' => (int) $a->trimestre,
                'calificacion' => $insc?->calificacion !== null ? strtoupper($insc->calificacion) : null,
                'estado' => $insc?->estado ?? 'pendiente',
            ];
        })->all();

        return $this->ok($resultado);
    }

    /**
     * PUT /api/asignaturas.php → inscribir / actualizar estado de una asignatura.
     */
    public function update(Request $request)
    {
        $user = Auth::user();
        $input = $request->all();

        $id = (int) ($input['id'] ?? 0);
        $nuevoEstado = $input['estado'] ?? '';
        $calificacion = $input['calificacion'] ?? null;

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

        if ($calificacion !== null) {
            $calificacion = strtoupper(trim((string) $calificacion));
            if (! in_array($calificacion, ['A', 'B', 'C'], true)) {
                return $this->fail('Calificación inválida: debe ser A, B o C');
            }
        }

        if ($nuevoEstado === 'pendiente') {
            Inscripcion::where('usuario_id', $user->id)
                ->where('asignatura_id', $id)
                ->delete();
        } else {
            if ($nuevoEstado !== 'aprobada') {
                $calificacion = null;
            }

            Inscripcion::updateOrCreate(
                ['usuario_id' => $user->id, 'asignatura_id' => $id],
                ['estado' => $nuevoEstado, 'calificacion' => $calificacion]
            );
        }

        return $this->ok(['mensaje' => 'Estado actualizado', 'id' => $id, 'estado' => $nuevoEstado]);
    }
}
