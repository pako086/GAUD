<?php

use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::prefix('api')->group(function () {
    Route::get('auth.php', [AuthController::class, 'me']);
    Route::post('auth.php', [AuthController::class, 'handlePost']);
});
