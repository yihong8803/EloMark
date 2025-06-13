<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
//use App\Http\Controllers\AuthController;
use App\Http\Controllers\CourseController;
use App\Http\Controllers\ExamMarkController;
use App\Http\Controllers\StudentController;

// //Public Routes
// Route::post('/register', [AuthController::class, 'register']);
// Route::post('/login', [AuthController::class, 'login']);

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
    Route::get('/exam-marks', [ExamMarkController::class, 'index']);
    Route::post('/exam-marks', [ExamMarkController::class, 'store']);
    Route::get('/exam-marks/student/{student_id}/course/{course_id}', [ExamMarkController::class, 'show']);
Route::put('/exam-marks/student/{student_id}/course/{course_id}', [ExamMarkController::class, 'update']);
Route::delete('/exam-marks/student/{student_id}/course/{course_id}', [ExamMarkController::class, 'destroy']);

    //Student
    Route::get('/students', [StudentController::class, 'index']);
    Route::post('/students', [StudentController::class, 'store']);
    Route::post('/students/{id}/image', [StudentController::class, 'updateImage']);
    Route::get('/students/{id}', [StudentController::class, 'show']);
    Route::put('/students/{id}', [StudentController::class, 'update']);
    Route::delete('/students/{id}', [StudentController::class, 'destroy']);
//});