import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillmentor/baseurl.dart';
import 'AdminHomeScreen.dart';

class AddInstructorScreen extends StatefulWidget {
  @override
  _AddInstructorScreenState createState() => _AddInstructorScreenState();
}

class _AddInstructorScreenState extends State<AddInstructorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _instructorNameController = TextEditingController();
  final TextEditingController _instructorEmailController = TextEditingController();

  String? _selectedSubject;
  String _qualification = '';
  List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/subjects/'));
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> subjectsData = List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          subjects = subjectsData;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading subjects: $error')));
    }
  }

  void _addInstructor() async {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> instructorData = {
        'role': 'Instructor',
        'email': _instructorEmailController.text.trim(),
        'name': _instructorNameController.text.trim(),
        'subjects': _selectedSubject,
        'qualification': _qualification,
      };

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/AdminAddInstructor'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(instructorData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Instructor added successfully! Credentials sent via email.')));
          _instructorNameController.clear();
          _instructorEmailController.clear();
          setState(() {
            _selectedSubject = null;
            _qualification = '';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add instructor.')));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Instructor'), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_instructorNameController, 'Instructor Name', Icons.person, true),
              _buildTextField(_instructorEmailController, 'Instructor Email', Icons.email, true),
              _buildDropdownField('Subject', _selectedSubject, subjects, (value) => _selectedSubject = value),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addInstructor,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                child: Text('Add Instructor', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => isRequired && (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<Map<String, dynamic>> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text('Select $label'),
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['id'].toString(),
            child: Text(item['name'] ?? item['subject_name']),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.business, color: Colors.deepPurpleAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null ? 'Please select a $label' : null,
      ),
    );
  }
}
