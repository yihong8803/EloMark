import 'package:elomark/models/course.dart';
import 'package:elomark/screens/admin/add_course_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/page_home_admin.dart';
import 'package:elomark/services/course_service.dart';
import 'package:flutter/material.dart';

class CourseSelectionPage extends StatefulWidget {
  const CourseSelectionPage({super.key});

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = true;
  String? _error;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final response = await CourseService.getCourses();
    if (response.error == null) {
      setState(() {
        _allCourses = response.data!;
        _filteredCourses = _allCourses;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = response.error;
        _isLoading = false;
      });
    }
  }

  void _filterCourses(String query) {
    setState(() {
      _searchText = query;
      _filteredCourses =
          _allCourses.where((course) {
            final name = course.courseName.toLowerCase();
            final code = course.courseCode.toLowerCase();
            return name.contains(query.toLowerCase()) ||
                code.contains(query.toLowerCase());
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Selection'),
        backgroundColor: Colors.blue,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by course code or name',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: _filterCourses,
                    ),
                  ),
                  Expanded(
                    child:
                        _filteredCourses.isEmpty
                            ? const Center(child: Text("No courses found."))
                            : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              itemCount: _filteredCourses.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final course = _filteredCourses[index];
                                return InkWell(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => MarkPage(course: course),
                                      ),
                                    );

                                    if (result == 'refresh') {
                                      _fetchCourses(); // Refresh after deletion
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          course.courseCode,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            course.courseName,
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? isCourseAdded = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCoursePage()),
          );
          // Reload courses if a new one was added
          if (isCourseAdded == true) {
            _fetchCourses();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color(0xFFF2F4F8),
    );
  }
}
