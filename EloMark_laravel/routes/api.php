<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
//use App\Http\Controllers\AuthController;
use App\Http\Controllers\CourseController;
use App\Http\Controllers\ExamMarkController;
use App\Http\Controllers\StudentController;

// //Public Routes
// Route::post('/register', [AuthController::class, 'register']);


// // Protected Routes
// Route::group(['middleware' => ['auth:sanctum']], function () {

//     // Auth
//     Route::get('/user', [AuthController::class, 'user']);
//     Route::post('/logout', [AuthController::class, 'logout']);

    // Course CRUD
    Route::get('/courses', [CourseController::class, 'index']);
    Route::post('/courses', [CourseController::class, 'store']);
    Route::get('/courses/{id}', [CourseController::class, 'show']);
    Route::put('/courses/{id}', [CourseController::class, 'update']);
    Route::delete('/courses/{id}', [CourseController::class, 'destroy']);

    //Mark
    Route::get('/exam_marks', [ExamMarkController::class, 'index']);
    Route::post('/exam_marks', [ExamMarkController::class, 'store']);

    //Get the mark from all course for a specific student id
    Route::get('/exam_marks/students/{student_id}', [ExamMarkController::class, 'getByStudent']);
    
    //Get the mark from all student for a specific course
    Route::get('/exam_marks/courses/{course_id}', [ExamMarkController::class, 'getByCourse']);
    Route::get('/exam_marks/students/{student_id}/course/{course_id}', [ExamMarkController::class, 'show']);
    Route::put('/exam_marks/students/{student_id}/course/{course_id}', [ExamMarkController::class, 'update']);
    Route::delete('/exam_marks/students/{student_id}/course/{course_id}', [ExamMarkController::class, 'destroy']);

    //Student In Corresponding Course
    //Useless
    Route::get('/students/courses/{course_id}', [StudentController::class, 'getStudentsByCourse']);

    //Student
    Route::post('/students/login', [StudentController::class, 'login']);
    Route::get('/students', [StudentController::class, 'index']);
    Route::post('/students', [StudentController::class, 'store']);
    Route::post('/students/{id}/image', [StudentController::class, 'updateImage']);
    Route::get('/students/{id}', [StudentController::class, 'show']);
    Route::put('/students/{id}', [StudentController::class, 'update']);
    Route::delete('/students/{id}', [StudentController::class, 'destroy']);
//});