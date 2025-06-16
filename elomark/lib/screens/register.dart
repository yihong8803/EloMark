import 'package:animate_do/animate_do.dart';
import 'package:elomark/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Add image picker

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? base64Image;
  File? imageFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
        base64Image = base64Encode(imageFile!.readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F3F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 60),
              width: double.infinity,
              color: Color.fromRGBO(143, 148, 251, 1),
              child: FadeInDown(
                duration: Duration(milliseconds: 800),
                child: Column(
                  children: [
                    Icon(Icons.person_add_alt_1, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: TextFormField(
                        controller: studentIdController,
                        decoration: InputDecoration(
                          labelText: "Student ID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Student ID';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Student ID must be numeric';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1100),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Enter your name' : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1200),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator:
                            (value) =>
                                value!.length < 6
                                    ? 'Minimum 6 characters'
                                    : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1400),
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              SizedBox(width: 10),
                              Text(
                                base64Image != null
                                    ? "Image Selected"
                                    : "Upload Profile Image",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 1500),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final response = await http.post(
                                Uri.parse(studentURL),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({
                                  'student_id': studentIdController.text.trim(),
                                  'student_name': nameController.text.trim(),
                                  'student_email': emailController.text.trim(),
                                  'password': passwordController.text,
                                  'image': base64Image ?? '',
                                }),
                              );
                              debugPrint(
                                'Redirected to: ${response.headers['location']}',
                              );
                              debugPrint('Headers: ${response.headers}');
                              debugPrint(
                                'Response Status: ${response.statusCode}',
                              );
                              debugPrint('Response Body: ${response.body}');

                              if (response.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Registration successful"),
                                  ),
                                );
                                Navigator.pop(context);
                              } else if (response.statusCode == 422) {
                                // Laravel validation error
                                final body = jsonDecode(response.body);
                                final errors =
                                    body['errors'] as Map<String, dynamic>;
                                final firstError =
                                    errors
                                        .values
                                        .first[0]; // show first validation error

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(firstError)),
                                );
                              } else if (response.statusCode == 500) {
                                final body = jsonDecode(response.body);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Server error: ${body['error'] ?? somethingWentWrong}",
                                    ),
                                  ),
                                );
                              } else {
                                // Other unexpected error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Error: ${response.statusCode}",
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint('Exception: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(serverError)),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 1600),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: Color.fromRGBO(143, 148, 251, 1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
