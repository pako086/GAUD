<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Universidad extends Model
{
    protected $table = 'universidades';

    public $timestamps = false;

    protected $fillable = [
        'nombre',
    ];

    public function carreras()
    {
        return $this->hasMany(Carrera::class);
    }

    public function usuarios()
    {
        return $this->hasMany(Usuario::class);
    }
}
