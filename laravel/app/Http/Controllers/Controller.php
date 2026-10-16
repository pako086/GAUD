<?php

namespace App\Http\Controllers;

use App\Models\Usuario;
use Illuminate\Http\JsonResponse;

abstract class Controller
{
    protected function ok(array $data, int $code = 200): JsonResponse
    {
        return response()->json(['ok' => true, 'data' => $data], $code);
    }

    protected function fail(string $error, int $code = 400): JsonResponse
    {
        return response()->json(['ok' => false, 'error' => $error], $code);
    }

    protected function perfilBase(Usuario $user): array
    {
        return [
            'id' => $user->id,
            'nombre' => $user->nombre,
            'email' => $user->email,
            'telefono' => $user->telefono,
            'direccion' => $user->direccion,
            'universidad' => $user->universidad?->nombre,
            'carrera' => $user->carrera?->nombre,
            'universidad_id' => $user->universidad_id,
            'carrera_id' => $user->carrera_id,
            'modalidad' => $user->modalidad,
            'terminos_aceptado_en' => $user->terminos_aceptado_en?->format('Y-m-d H:i:s'),
            'creado_en' => $user->creado_en?->format('Y-m-d H:i:s'),
        ];
    }
}
