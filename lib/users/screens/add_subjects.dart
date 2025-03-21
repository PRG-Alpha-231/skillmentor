import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillmentor/baseurl.dart';
import 'dart:convert';
import 'add_instructor.dart';

class AddSubjectScreen extends StatefulWidget {
  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectDescriptionController = TextEditingController();

  List<Map<String, dynamic>> subjects = [];
  List<Map<String, dynamic>> departments = [];
  String? selectedDepartmentId;
  String? selectedDepartmentName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
    _fetchSubjects();
  }

  // Fetch departments from the backend

  Future<void> _fetchDepartments() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final instituteId = prefs.getString('institute_id');
  final String apiUrl = '$baseUrl/api/institutes/$instituteId/departments/';
  print(apiUrl);

  try {
    final response = await http.get(Uri.parse(apiUrl));
    print(response.body);  

    if (response.statusCode == 200) {
      // Check if the response is JSON
      if (response.headers['content-type']?.contains('application/json') ?? false) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          departments = data.map((dept) => {
            'id': dept['id'].toString(),
            'name': dept['name'],
            'description': dept['description']  // Add description if needed
          }).toList();
        });
      } else {
        print('Response is not JSON: ${response.body}');
      }
    } else {
      print('Failed to load departments. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error fetching departments: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  // Fetch subjects from the backend
  Future<void> _fetchSubjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final instituteId = prefs.getString('institute_id');
    final String apiUrl = '$baseUrl/api/institutes/$instituteId/subjects/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          subjects = data.map((subject) => {
            'id': subject['id'].toString(),
            'name': subject['subject_name'],
            'code': subject['department'].toString(),
            'description': subject['description'] ?? '',
          }).toList();
        });
      } else {
        print('Failed to load subjects');
      }
    } catch (e) {
      print('Error fetching subjects: $e');
    }
  }

  // Add a subject to the backend
  Future<void> _addSubject() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (selectedDepartmentId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a department')),
        );
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final instituteId = prefs.getString('institute_id');
      final String apiUrl = '$baseUrl/api/add-subject/';

      print(selectedDepartmentId);


      Map<String, dynamic> newSubject = {
        "subject_name": _subjectNameController.text.trim(),
        "description": _subjectDescriptionController.text.trim(),
        "department": selectedDepartmentId,
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(newSubject),
        );

        if (response.statusCode == 201) {
          final newSubjectData = json.decode(response.body);
          setState(() {
            subjects.add({
              'id': newSubjectData['id'].toString(),
              'name': _subjectNameController.text.trim(),
              'code': selectedDepartmentId!,
              'description': _subjectDescriptionController.text.trim(),
            });
          });

          _subjectNameController.clear();
          _subjectDescriptionController.clear();
          selectedDepartmentId = null;
          selectedDepartmentName = null;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Subject added successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add subject: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error adding subject: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding subject: $e')),
        );
      }
    }
  }

  // Delete a subject from the backend
  Future<void> _deleteSubject(int index) async {
    String subjectId = subjects[index]['id'];
    final String apiUrl = '$baseUrl/api/subjects/$subjectId/';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 204) {
        setState(() {
          subjects.removeAt(index);
        });
      } else {
        print('Failed to delete subject: ${response.body}');
      }
    } catch (e) {
      print('Error deleting subject: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Subject'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_subjectNameController, 'Subject Name', Icons.book, true),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        title: Text(
                          selectedDepartmentName ?? 'Select Department',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        leading: Icon(Icons.business, color: Colors.deepPurpleAccent),
                        children: departments.map((dept) {
                          return ListTile(
                            title: Text(dept['name']),
                            onTap: () {
                              setState(() {
                                selectedDepartmentId = dept['id'];
                                selectedDepartmentName = dept['name'];
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  _buildTextField(_subjectDescriptionController, 'Description', Icons.description, false, maxLines: 3),
                  SizedBox(height: 20),

                  // Add Subject Button with Gradient Style
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _addSubject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero, // Removing padding for the gradient to show
                          ),
                          child: Text(
                            'Add Subject',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            subjects.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final departmentName = departments.firstWhere(
                        (dept) => dept['id'] == subject['code'],
                    orElse: () => {'name': 'Unknown'})['name'];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(subject['name'] ?? ''),
                    subtitle: Text('Department: $departmentName \nDescription: ${subject['description']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteSubject(index),
                    ),
                  ),
                );
              },
            )
                : Center(child: Text('No subjects added yet.', style: TextStyle(color: Colors.grey))),

            SizedBox(height: 20),
            // Next Button with Gradient Style
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Pass the subjects to AddInstructorScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddInstructorScreen(), // Passing subjects here
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero, // Removing padding for the gradient to show
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isRequired, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
