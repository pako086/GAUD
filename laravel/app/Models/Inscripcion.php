<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Inscripcion extends Model
{
    protected $table = 'inscripciones';

    public $timestamps = false;

    protected $fillable = [
        'usuario_id',
        'asignatura_id',
        'estado',
        'calificacion',
    ];

    protected function casts(): array
    {
        return [
            'actualizado_en' => 'datetime',
        ];
    }

    public function usuario()
    {
        return $this->belongsTo(Usuario::class);
    }

    public function asignatura()
    {
        return $this->belongsTo(Asignatura::class);
    }
}
