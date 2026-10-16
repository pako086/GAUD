<?php

namespace App\Http\Controllers;

use App\Models\Carrera;
use App\Models\Universidad;

class CatalogoController extends Controller
{
    /**
     * GET /api/catalogo.php → universidades con sus carreras (público).
     */
    public function index()
    {
        $universidades = Universidad::orderBy('nombre')->get();

        $carrerasPorUni = Carrera::orderBy('nombre')->get()->groupBy('universidad_id');

        $resultado = $universidades->map(function ($u) use ($carrerasPorUni) {
            return [
                'id' => (int) $u->id,
                'nombre' => $u->nombre,
                'carreras' => ($carrerasPorUni->get($u->id) ?? collect())->map(fn ($c) => [
                    'id' => (int) $c->id,
                    'nombre' => $c->nombre,
                ])->values()->all(),
            ];
        })->all();

        return $this->ok(['universidades' => $resultado]);
    }
}
