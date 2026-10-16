<?php

namespace App\Http\Controllers;

use App\Models\Carrera;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    /**
     * POST /api/usuarios.php -> crear cuenta (registro). No requiere autenticación.
     */
    public function store(Request $request)
    {
        $input = $request->all();

        $nombre = trim((string) ($input['nombre'] ?? ''));
        $email = trim((string) ($input['email'] ?? ''));
        $password = (string) ($input['password'] ?? '');
        $telefono = trim((string) ($input['telefono'] ?? '')) ?: null;
        $direccion = trim((string) ($input['direccion'] ?? '')) ?: null;
        $universidad_id = (int) ($input['universidad_id'] ?? 0);
        $carrera_id = (int) ($input['carrera_id'] ?? 0);
        $modalidad = (string) ($input['modalidad'] ?? '');
        $terminos = $input['terminos_aceptados'] ?? false;

        if ($nombre === '' || $email === '' || $password === '' || $universidad_id <= 0 || $carrera_id <= 0 || $modalidad === '') {
            return $this->fail('Nombre, email, contraseña, universidad, carrera y modalidad son obligatorios');
        }
        if (strlen($password) < 8) {
            return $this->fail('La contraseña debe tener al menos 8 caracteres');
        }
        if (! filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return $this->fail('Email inválido');
        }
        if (! in_array($modalidad, ['presencial', 'virtual', 'mixta'], true)) {
            return $this->fail('Modalidad inválida');
        }
        if (! $terminos) {
            return $this->fail('Debes aceptar los términos y condiciones');
        }
        if (! $this->carreraPerteneceUniversidad($universidad_id, $carrera_id)) {
            return $this->fail('La carrera no pertenece a la universidad seleccionada');
        }
        if (Usuario::where('email', $email)->exists()) {
            return $this->fail('Este email ya está registrado', 409);
        }

        $user = new Usuario();
        $user->nombre = $nombre;
        $user->email = $email;
        $user->password_hash = password_hash($password, PASSWORD_DEFAULT);
        $user->telefono = $telefono;
        $user->direccion = $direccion;
        $user->universidad_id = $universidad_id;
        $user->carrera_id = $carrera_id;
        $user->modalidad = $modalidad;
        $user->terminos_aceptado_en = now();
        $user->save();

        Auth::login($user);
        $request->session()->regenerate();

        return $this->ok(['id' => $user->id, 'mensaje' => 'Cuenta creada'], 201);
    }

    /**
     * GET /api/usuarios.php -> perfil del usuario autenticado.
     */
    public function get()
    {
        return $this->ok($this->perfilBase(Auth::user()));
    }

    /**
     * PUT /api/usuarios.php -> actualizar perfil.
     * PUT /api/usuarios.php?action=password -> cambiar contraseña.
     */
    public function handlePut(Request $request)
    {
        if ($request->query('action') === 'password') {
            return $this->password($request);
        }

        return $this->update($request);
    }

    protected function update(Request $request)
    {
        $user = Auth::user();
        $input = $request->all();

        $nombre = trim((string) ($input['nombre'] ?? ''));
        $email = isset($input['email']) ? trim((string) $input['email']) : null;
        $telefono = trim((string) ($input['telefono'] ?? '')) ?: null;
        $direccion = trim((string) ($input['direccion'] ?? '')) ?: null;
        $universidad_id = (int) ($input['universidad_id'] ?? 0);
        $carrera_id = (int) ($input['carrera_id'] ?? 0);
        $modalidad = (string) ($input['modalidad'] ?? '');

        if ($nombre === '' || $universidad_id <= 0 || $carrera_id <= 0 || $modalidad === '') {
            return $this->fail('Nombre, universidad, carrera y modalidad son obligatorios');
        }
        if (! in_array($modalidad, ['presencial', 'virtual', 'mixta'], true)) {
            return $this->fail('Modalidad inválida');
        }
        if (! $this->carreraPerteneceUniversidad($universidad_id, $carrera_id)) {
            return $this->fail('La carrera no pertenece a la universidad seleccionada');
        }
        if ($email !== null) {
            if ($email === '' || ! filter_var($email, FILTER_VALIDATE_EMAIL)) {
                return $this->fail('Email inválido');
            }
            if (Usuario::where('email', $email)->where('id', '!=', $user->id)->exists()) {
                return $this->fail('Este email ya está registrado', 409);
            }
        }

        $user->nombre = $nombre;
        $user->email = $email ?? $user->email;
        $user->telefono = $telefono;
        $user->direccion = $direccion;
        $user->universidad_id = $universidad_id;
        $user->carrera_id = $carrera_id;
        $user->modalidad = $modalidad;
        $user->save();

        return $this->ok(['mensaje' => 'Perfil actualizado']);
    }

    protected function password(Request $request)
    {
        $user = Auth::user();
        $input = $request->all();

        $actual = (string) ($input['password_actual'] ?? '');
        $nueva = (string) ($input['password_nueva'] ?? '');
        $confirmar = (string) ($input['password_confirmar'] ?? '');

        if ($actual === '' || $nueva === '' || $confirmar === '') {
            return $this->fail('Debes ingresar la contraseña actual, la nueva y la confirmación');
        }
        if (strlen($nueva) < 8) {
            return $this->fail('La nueva contraseña debe tener al menos 8 caracteres');
        }
        if ($nueva !== $confirmar) {
            return $this->fail('La contraseña nueva y la confirmación no coinciden');
        }
        if (! password_verify($actual, $user->password_hash)) {
            return $this->fail('La contraseña actual es incorrecta');
        }

        $user->password_hash = password_hash($nueva, PASSWORD_DEFAULT);
        $user->save();

        return $this->ok(['mensaje' => 'Contraseña actualizada']);
    }

    /**
     * DELETE /api/usuarios.php -> eliminar cuenta.
     */
    public function destroy(Request $request)
    {
        $user = Auth::user();
        $user->delete();

        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return $this->ok(['mensaje' => 'Cuenta eliminada']);
    }

    protected function carreraPerteneceUniversidad(int $universidadId, int $carreraId): bool
    {
        return Carrera::where('id', $carreraId)
            ->where('universidad_id', $universidadId)
            ->exists();
    }
}
