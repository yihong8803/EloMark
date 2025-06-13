<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('exam_marks', function (Blueprint $table) {
            $table->id(); // ✅ Auto-increment primary key
            $table->unsignedBigInteger('student_id');
            $table->unsignedBigInteger('course_id');
            $table->integer('mark');
            $table->timestamps();

            $table->foreign('student_id')->references('student_id')->on('students')->onDelete('cascade');
            $table->foreign('course_id')->references('course_id')->on('courses')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('exam_marks');
    }
};