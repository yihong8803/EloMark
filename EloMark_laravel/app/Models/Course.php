<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Course extends Model
{
    use HasFactory;

    protected $primaryKey = 'course_id'; // Important
    public $incrementing = true;
    protected $keyType = 'int';

    protected $fillable = ['course_name', 'course_code'];

    public function examMarks()
    {
        return $this->hasMany(ExamMark::class, 'course_id');
    }
}
