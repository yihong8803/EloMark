<?php

namespace App\Http\Controllers;

use App\Models\ExamMark;
use Illuminate\Http\Request;

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

    public function update(Request $request, $id)
    {
        $examMark = ExamMark::findOrFail($id);
        $request->validate([
            'mark' => 'nullable|integer|min:0|max:100',
        ]);
        $examMark->update($request->only('mark'));
        return $examMark;
    }

    public function destroy($id)
    {
        ExamMark::destroy($id);
        return response()->json(['message' => 'Exam mark deleted']);
    }
}
