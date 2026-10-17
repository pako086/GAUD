<?php

namespace App\Http\Controllers;

use App\Models\Inscripcion;
use App\Models\Usuario;
use App\Services\Academico;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function __construct(protected Academico $academico)
    {
    }

    /**
     * GET /api/auth.php -> datos del usuario autenticado o 401.
     */
    public function me()
    {
        $user = Auth::user();

        if (! $user) {
            return $this->fail('No autenticado', 401);
        }

        return $this->respondUsuario($user);
    }

    /**
     * POST /api/auth.php -> login.
     * POST /api/auth.php?action=logout -> logout.
     */
    public function handlePost(Request $request)
    {
        if ($request->query('action') === 'logout') {
            return $this->logout($request);
        }

        return $this->login($request);
    }

    protected function login(Request $request)
    {
        $email = trim((string) $request->input('email', ''));
        $password = (string) $request->input('password', '');

        if ($email === '' || $password === '') {
            return $this->fail('Email y contraseña son obligatorios', 422);
        }

        $user = Usuario::where('email', $email)->first();

        if (! $user || ! password_verify($password, $user->password_hash)) {
            return $this->fail('Credenciales inválidas', 401);
        }

        Auth::login($user);
        $request->session()->regenerate();

        return $this->respondUsuario($user, 201);
    }

    protected function logout(Request $request)
    {
        Auth::logout();

        if ($request->session()) {
            $request->session()->invalidate();
            $request->session()->regenerateToken();
        }

        return $this->ok(['mensaje' => 'Sesión cerrada']);
    }

    protected function respondUsuario(Usuario $user, int $code = 200)
    {
        $inscripciones = $this->inscripcionesDelUsuario($user->id);

        $data = $this->perfilBase($user);
        $data['periodo_actual'] = $this->academico->calcularPeriodo($inscripciones);

        return $this->ok($data, $code);
    }

    /**
     * @return array<int, array{periodo:int, creditos:int, estado:?string, calificacion:?string}>
     */
    protected function inscripcionesDelUsuario(int $usuarioId): array
    {
        return Inscripcion::where('usuario_id', $usuarioId)
            ->with('asignatura')
            ->get()
            ->map(fn ($i) => [
                'periodo' => (int) $i->asignatura->periodo,
                'creditos' => (int) $i->asignatura->creditos,
                'estado' => $i->estado,
                'calificacion' => $i->calificacion,
            ])
            ->values()
            ->all();
    }
}
