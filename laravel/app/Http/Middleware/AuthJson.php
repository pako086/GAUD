<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class AuthJson
{
    public function handle(Request $request, Closure $next): Response
    {
        if (! Auth::check()) {
            return response()->json(['ok' => false, 'error' => 'No autenticado'], 401);
        }

        return $next($request);
    }
}
