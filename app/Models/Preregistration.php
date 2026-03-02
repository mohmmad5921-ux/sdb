<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Preregistration extends Model
{
    protected $fillable = ['full_name', 'email', 'phone', 'country', 'ip_address'];
}
