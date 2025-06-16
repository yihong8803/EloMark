<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    use HasFactory;

    protected $table = 'students';
    protected $primaryKey = 'student_id';
    public $incrementing = false;
    protected $keyType = 'string'; // or 'int' if purely numeric

    protected $fillable = [
    'student_id',
    'student_name',
    'student_email',
    'image',
    'password',
];

    public function examMarks()
    {
        return $this->hasMany(ExamMark::class);
    }
}