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
        'trimestre',
        'carrera_id',
    ];

    protected function casts(): array
    {
        return [
            'creditos' => 'integer',
            'trimestre' => 'integer',
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
}
