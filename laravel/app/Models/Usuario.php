<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class Usuario extends Authenticatable
{
    use Notifiable;

    protected $table = 'usuarios';

    public $timestamps = false;

    protected $fillable = [
        'nombre',
        'email',
        'password_hash',
        'telefono',
        'direccion',
        'universidad_id',
        'carrera_id',
        'modalidad',
        'terminos_aceptado_en',
    ];

    protected $hidden = [
        'password_hash',
    ];

    protected function casts(): array
    {
        return [
            'terminos_aceptado_en' => 'datetime',
            'creado_en' => 'datetime',
        ];
    }

    public function getAuthPasswordName(): string
    {
        return 'password_hash';
    }

    public function universidad()
    {
        return $this->belongsTo(Universidad::class);
    }

    public function carrera()
    {
        return $this->belongsTo(Carrera::class);
    }

    public function inscripciones()
    {
        return $this->hasMany(Inscripcion::class);
    }
}
