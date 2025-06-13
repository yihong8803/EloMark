<?php

namespace App\Http\Controllers;

use App\Models\Course;
use Illuminate\Http\Request;

class CourseController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Course::select('course_id', 'course_name', 'course_code')->get();
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'course_name' => 'required|string',
            'course_code' => 'required|string|unique:courses',
        ]);

        $course = Course::create($request->only('course_name', 'course_code'));

        return response()->json([
            'course_id' => $course->course_id,
            'course_name' => $course->course_name,
            'course_code' => $course->course_code,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $course = Course::select('course_id', 'course_name', 'course_code')->findOrFail($id);
        return $course;
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $course = Course::findOrFail($id);
        $course->update($request->only('course_name', 'course_code'));

        return response()->json([
            'course_id' => $course->course_id,
            'course_name' => $course->course_name,
            'course_code' => $course->course_code,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        Course::destroy($id);
        return response()->json(['message' => 'Course deleted']);
    }
}
