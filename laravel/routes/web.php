<?php

use App\Http\Controllers\AsignaturaController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CatalogoController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\AuthJson;
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/index.html');

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

    // Catálogo (público)
    Route::get('catalogo.php', [CatalogoController::class, 'index']);

    // Académico (autenticado)
    Route::middleware(AuthJson::class)->group(function () {
        Route::get('dashboard.php', [DashboardController::class, 'index']);
        Route::get('asignaturas.php', [AsignaturaController::class, 'index']);
        Route::put('asignaturas.php', [AsignaturaController::class, 'update']);
    });
});
