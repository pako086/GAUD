<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\AuthJson;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::prefix('api')->group(function () {
    // Autenticación
    Route::get('auth.php', [AuthController::class, 'me']);
    Route::post('auth.php', [AuthController::class, 'handlePost']);

    // Usuarios
    Route::post('usuarios.php', [UserController::class, 'store']);
    Route::middleware(AuthJson::class)->group(function () {
        Route::get('usuarios.php', [UserController::class, 'get']);
        Route::put('usuarios.php', [UserController::class, 'handlePut']);
        Route::delete('usuarios.php', [UserController::class, 'destroy']);
    });
});
