<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Asignatura extends Model
{
    protected $table = 'asignaturas';

    public $timestamps = false;

    protected $fillable = [
        'codigo',
        'nombre',
        'creditos',
        'periodo',
        'tipo',
        'carrera_id',
    ];

    protected function casts(): array
    {
        return [
            'creditos' => 'integer',
            'periodo' => 'integer',
        ];
    }

    public function carrera()
    {
        return $this->belongsTo(Carrera::class);
    }

    public function inscripciones()
    {
        return $this->hasMany(Inscripcion::class);
    }

    public function prerrequisitos()
    {
        return $this->belongsToMany(Asignatura::class, 'asignatura_relaciones', 'asignatura_id', 'relacionada_id')
            ->wherePivot('tipo', 'prerrequisito');
    }

    public function correquisitos()
    {
        return $this->belongsToMany(Asignatura::class, 'asignatura_relaciones', 'asignatura_id', 'relacionada_id')
            ->wherePivot('tipo', 'correquisito');
    }
}
