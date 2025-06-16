<?php

namespace App\Http\Controllers;

use App\Models\ExamMark;
use Illuminate\Http\Request;
use App\Models\Student;

class ExamMarkController extends Controller
{
    public function index()
    {
        return ExamMark::with(['student:student_id,student_name', 'course:course_id,course_name,course_code'])->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'student_id' => 'required|exists:students,student_id',
            'course_id' => 'required|exists:courses,course_id',
            'mark' => 'required|integer|min:0|max:100',
        ]);

        return ExamMark::create($request->only('student_id', 'course_id', 'mark'));
    }

    public function show($id)
    {
        $examMark = ExamMark::with(['student', 'course'])->findOrFail($id);
        return response()->json($examMark);
    }

    public function update(Request $request, $student_id, $course_id)
{
    $examMark = ExamMark::where('student_id', $student_id)
                        ->where('course_id', $course_id)
                        ->firstOrFail(); // this throws the 404 error you're seeing

    $examMark->mark = $request->input('mark');
    $examMark->save();

    return response()->json(['success' => true, 'message' => 'Mark updated']);
}

    public function destroy($student_id, $course_id)
    {
        $mark = ExamMark::where('student_id', $student_id)
                        ->where('course_id', $course_id)
                        ->first();

        if (!$mark) {
            return response()->json([
                'success' => false,
                'message' => 'Mark not found for this student in the specified course.'
            ], 404);
        }

        $mark->delete();

        return response()->json([
            'success' => true,
            'message' => 'Mark deleted successfully.'
        ]);
    }

    public function getByStudent($student_id)
{
    $student = Student::find($student_id);

    if (!$student) {
        return response()->json(['message' => 'Student not found'], 404);
    }

    $marks = ExamMark::with('course')
        ->where('student_id', $student_id)
        ->get();

    return response()->json([
        'student' => $student,
        'marks' => $marks,
    ], 200);
}

    // ✅ Add this function at the bottom of the controller
    public function getByCourse($course_id)
    {
        $marks = ExamMark::with(['student:student_id,student_name', 'course:course_id,course_name,course_code'])
                    ->where('course_id', $course_id)
                    ->get();

        return response()->json([
            'success' => true,
            'data' => $marks
        ]);
    }
}
