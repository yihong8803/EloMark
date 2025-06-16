<?php

namespace App\Http\Controllers;

use App\Models\Student;
use App\Models\ExamMark;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;

class StudentController extends Controller
{
    public function index()
    {
        return Student::select('student_id', 'student_name', 'student_email', 'image')->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'student_id' => 'required|string|unique:students',
            'student_name' => 'required|string',
            'student_email' => 'required|email|unique:students',
            'image' => 'nullable|string',
            'password' => 'required|string|min:6',
        ]);

        $imageUrl = $this->saveImage($request->image ?? null, 'student_images');

        $student = Student::create([
            'student_id' => $request->student_id,
            'student_name' => $request->student_name,
            'student_email' => $request->student_email,
            'image' => $imageUrl,
            'password' => $request->password,
        ]);

        return response()->json($student, 201);
    }

    public function show($id)
    {
        return Student::select('student_id', 'student_name', 'student_email', 'image','password')->findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $student = Student::findOrFail($id);
        $student->update($request->only('student_name', 'student_email'));

        return response()->json($student);
    }

    public function destroy($id)
    {
        Student::destroy($id);
        return response()->json(['message' => 'Student deleted']);
    }

    // ✅ NEW: Get all students from a selected course
    public function getStudentsByCourse($course_id)
    {
        $students = ExamMark::with('student')
            ->where('course_id', $course_id)
            ->get()
            ->pluck('student')
            ->unique('student_id')
            ->values();

        return response()->json([
            'success' => true,
            'data' => $students
        ]);
    }

    // ✅ Already implemented: Update image
    public function updateImage(Request $request, $id)
    {
        $request->validate([
            'image' => 'required|string',
        ]);

        $student = Student::findOrFail($id);

        if ($student->image) {
            $oldPath = str_replace(URL::to('/') . '/storage/', '', $student->image);
            Storage::disk('public')->delete($oldPath);
        }

        $imageUrl = $this->saveImage($request->image, 'student_images');

        $student->image = $imageUrl;
        $student->save();

        return response()->json([
            'message' => 'image updated successfully',
            'image_url' => $imageUrl,
        ]);
    }
    
    //Login
    public function login(Request $request)
    {
        $request->validate([
            'student_id' => 'required|string',
            'password' => 'required|string',
        ]);

        $student = Student::where('student_id', $request->student_id)
            ->where('password', $request->password) // ⚠️ plain-text match
            ->first();

        if (!$student) {
            return response()->json(['message' => 'Invalid student ID or password'], 401);
        }

        return response()->json([
            'message' => 'Login successful',
            'student' => [
                'student_id' => $student->student_id,
                'student_name' => $student->student_name,
                'student_email' => $student->student_email,
                'image' => $student->image,
                'password' => $student->password,
            ]
        ]);
    }
}
