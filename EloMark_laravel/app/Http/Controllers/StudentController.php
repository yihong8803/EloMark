<?php

namespace App\Http\Controllers;

use App\Models\Student;
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
            'image' => 'nullable|string', // base64 image string
        ]);

        $imageUrl = $this->saveImage($request->image ?? null, 'student_images');

        $student = Student::create([
            'student_id' => $request->student_id,
            'student_name' => $request->student_name,
            'student_email' => $request->student_email,
            'image' => $imageUrl,
        ]);

        return response()->json($student, 201);
    }

    public function show($id)
    {
        return Student::select('student_id', 'student_name', 'student_email', 'image')->findOrFail($id);
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

    // ✅ Add this method for image update
    public function updateimage(Request $request, $id)
    {
        $request->validate([
            'image' => 'required|string', // base64 image string
        ]);

        $student = Student::findOrFail($id);

        // Delete old image if exists
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
    
}
