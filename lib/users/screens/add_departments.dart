import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillmentor/baseurl.dart';
import 'add_subjects.dart';

class AddDepartments extends StatefulWidget {
  @override
  _AddDepartmentsState createState() => _AddDepartmentsState();
}

class _AddDepartmentsState extends State<AddDepartments> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _departmentNameController = TextEditingController();
  final TextEditingController _departmentDescriptionController = TextEditingController();

  Future<void> _addDepartment() async {
    print('hi');
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final instituteId = prefs.getString('institute_id'); // Get institute ID

    if (instituteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Institute ID not found!')));
      return;
    }

    final url = Uri.parse('$baseUrl/api/add_Department/');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _departmentNameController.text,
        "description": _departmentDescriptionController.text,
        "institute": instituteId,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      print(responseData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Department added successfully!')));
      _departmentNameController.clear();
      _departmentDescriptionController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${responseData.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Department'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_departmentNameController, 'Department Name', Icons.business, true),
                    _buildTextField(_departmentDescriptionController, 'Description', Icons.description, false, maxLines: 3),
                    SizedBox(height: 20),
                    // Updated Add Department Button with Gradient Style
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _addDepartment, // Call API when clicked
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero, // Removing padding for the gradient to show
                            ),
                            child: Text(
                              'Add Department',
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
                    SizedBox(height: 20),
                    // Next Button to Navigate to AddSubjectsScreen
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [Colors.deepPurple, Colors.deepPurple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddSubjectScreen(), // Navigate to AddSubjectsScreen
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
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
            ],
          ),
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
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => isRequired && (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }
}
