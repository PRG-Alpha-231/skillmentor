import 'package:flutter/material.dart';

import 'add_instructor.dart';

class AddSubjectScreen extends StatefulWidget {
  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();
  final TextEditingController _subjectDescriptionController = TextEditingController();

  // List to store subjects
  List<Map<String, String>> subjects = [];

  // Function to add a subject
  void _addSubject() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        subjects.add({
          'name': _subjectNameController.text.trim(),
          'code': _subjectCodeController.text.trim(),
          'description': _subjectDescriptionController.text.trim(),
        });

        print('Added Subject: ${subjects.last}'); // Debugging
      });

      // Clear input fields
      _subjectNameController.clear();
      _subjectCodeController.clear();
      _subjectDescriptionController.clear();
    }
  }

  // Function to edit a subject
  void _editSubject(int index) {
    final subject = subjects[index];

    _subjectNameController.text = subject['name'] ?? '';
    _subjectCodeController.text = subject['code'] ?? '';
    _subjectDescriptionController.text = subject['description'] ?? '';

    setState(() {
      subjects.removeAt(index); // Remove from list before editing
    });
  }

  // Function to delete a subject
  void _deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Subject'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form for adding/editing subjects
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_subjectNameController, 'Subject Name', Icons.book, true),
                    _buildTextField(_subjectCodeController, 'Subject Code', Icons.code, true),
                    _buildTextField(_subjectDescriptionController, 'Description', Icons.description, false, maxLines: 3),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addSubject,
                      child: Text('Add Subject'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Display list of added subjects
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: subjects.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(subject['name'] ?? ''),
                        subtitle: Text('Code: ${subject['code']} \nDescription: ${subject['description']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => _editSubject(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteSubject(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Text('No subjects added yet.', style: TextStyle(color: Colors.grey)),
                ),
              ),

              // Next Button at Bottom (Navigates to External Page)
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddInstructorScreen())); // Navigates to external page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text field widget
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
