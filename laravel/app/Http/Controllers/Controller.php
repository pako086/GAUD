<?php

namespace App\Http\Controllers;

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
}
