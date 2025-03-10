import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skillmentor/baseurl.dart'; // Replace with your base URL

class IAddStudentScreen extends StatefulWidget {
  @override
  _IAddStudentScreenState createState() => _IAddStudentScreenState();
}

class _IAddStudentScreenState extends State<IAddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form fields
  String email = '';
  String firstName = '';
  String lastName = '';
  String? selectedDepartmentId; // Updated to store department ID
  String? selectedSubjectId;

  List<Map<String, dynamic>> subjects = []; // List of subjects fetched from the backend
  List<Map<String, dynamic>> departments = []; // List of departments fetched from the backend

  @override
  void initState() {
    super.initState();
    fetchSubjects(); // Fetch subjects when the screen loads
    fetchDepartments(); // Fetch departments when the screen loads
  }

  /// Fetch Subjects from the backend
  Future<void> fetchSubjects() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl/api/subjects/'); // Replace with your subjects API endpoint
      final response = await http.get(url);

      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          subjects = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Fetch Departments from the backend
  Future<void> fetchDepartments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl/api/departments/'); // Replace with your departments API endpoint
      final response = await http.get(url);

      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          departments = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Submit the form to add a new student
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      try {
        final url = Uri.parse('$baseUrl/api/students-add/'); // Updated to match Django URL
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'name': '$firstName $lastName', // Combine first and last name
            'subject': selectedSubjectId,
            'department_name': selectedDepartmentId,
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student added successfully!')),
          );
          Navigator.pop(context); // Go back to the previous screen
        } else {
          throw Exception('Failed to add student: ${response.body}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a first name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        firstName = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        lastName = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedDepartmentId,
                      items: departments.map((department) {
                        return DropdownMenuItem(
                          value: department['id'].toString(),
                          child: Text(department['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDepartmentId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a department';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedSubjectId,
                      items: subjects.map((subject) {
                        return DropdownMenuItem(
                          value: subject['id'].toString(),
                          child: Text(subject['subject_name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSubjectId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a subject';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Add Student'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}