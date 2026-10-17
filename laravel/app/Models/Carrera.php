<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Carrera extends Model
{
    protected $table = 'carreras';

    public $timestamps = false;

    protected $fillable = [
        'universidad_id',
        'nombre',
        'periodo',
    ];

    public function universidad()
    {
        return $this->belongsTo(Universidad::class);
    }

    public function asignaturas()
    {
        return $this->hasMany(Asignatura::class);
    }

    public function usuarios()
    {
        return $this->hasMany(Usuario::class);
    }
}
