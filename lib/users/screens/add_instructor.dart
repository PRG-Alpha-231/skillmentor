import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillmentor/baseurl.dart';

class AddInstructorScreen extends StatefulWidget {
  @override
  _AddInstructorScreenState createState() => _AddInstructorScreenState();
}

class _AddInstructorScreenState extends State<AddInstructorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _instructorNameController = TextEditingController();
  final TextEditingController _instructorEmailController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();

  String? _selectedSubject;
  List<Map<String, dynamic>> subjects = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/subjects/'));
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> subjectsData = List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          subjects = subjectsData;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading subjects: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addInstructor() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> instructorData = {
        'role': 'Instructor',
        'email': _instructorEmailController.text.trim(),
        'name': _instructorNameController.text.trim(),
        'subjects': _selectedSubject,
        'qualification': _qualificationController.text.trim(),
      };

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/AdminAddInstructor'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(instructorData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Instructor added successfully! Credentials sent via email.')),
          );
          _instructorNameController.clear();
          _instructorEmailController.clear();
          _qualificationController.clear();
          setState(() {
            _selectedSubject = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add instructor: ${response.body}')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Instructor', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_instructorNameController, 'Instructor Name', Icons.person, true),
              SizedBox(height: 16),
              _buildTextField(_instructorEmailController, 'Instructor Email', Icons.email, true, isEmail: true),
              SizedBox(height: 16),
              _buildTextField(_qualificationController, 'Instructor Qualification', Icons.school, true),
              SizedBox(height: 16),
              _buildDropdownField('Subject', _selectedSubject, subjects, (value) => setState(() => _selectedSubject = value)),
              SizedBox(height: 24),
              _isLoading
                  ? CircularProgressIndicator(color: Colors.deepPurple)
                  : ElevatedButton(
                      onPressed: _addInstructor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text(
                        'Add Instructor',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isRequired, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurpleAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, String? value, List<Map<String, dynamic>> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text('Select $label', style: TextStyle(color: Colors.deepPurpleAccent)),
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['id'].toString(),
          child: Text(item['name'] ?? item['subject_name'], style: TextStyle(color: Colors.deepPurple)),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.subject, color: Colors.deepPurpleAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurpleAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
      ),
      validator: (value) => value == null ? 'Please select a $label' : null,
    );
  }
}