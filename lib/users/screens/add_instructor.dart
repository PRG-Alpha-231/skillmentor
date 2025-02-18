import 'package:flutter/material.dart';
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

  List<Map<String, String>> instructors = []; // List to hold the instructors

  List<String> subjects = ['Math', 'Science', 'English', 'History']; // Example subjects

  // Function to add an instructor
  void _addInstructor() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        instructors.add({
          'name': _instructorNameController.text.trim(),
          'email': _instructorEmailController.text.trim(),
          'subject': _selectedSubject ?? '',
        });
      });

      // Clear input fields
      _instructorNameController.clear();
      _instructorEmailController.clear();
      _selectedSubject = null;
    }
  }

  // Function to edit an instructor
  void _editInstructor(int index) {
    final instructor = instructors[index];

    _instructorNameController.text = instructor['name'] ?? '';
    _instructorEmailController.text = instructor['email'] ?? '';
    _selectedSubject = instructor['subject'];

    setState(() {
      instructors.removeAt(index); // Remove from list before editing
    });
  }

  // Function to delete an instructor
  void _deleteInstructor(int index) {
    setState(() {
      instructors.removeAt(index);
    });
  }

  // Function to navigate to the Admin Home Screen
  void _navigateToNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Instructor'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(_instructorNameController, 'Instructor Name', Icons.person, true),
                          _buildTextField(_instructorEmailController, 'Instructor Email', Icons.email, true),
                          _buildDropdownField('Subject', _selectedSubject, subjects),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _addInstructor,
                            child: Text('Add Instructor'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: instructors.length,
                      itemBuilder: (context, index) {
                        final instructor = instructors[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(instructor['name'] ?? ''),
                            subtitle: Text('Email: ${instructor['email']} \nSubject: ${instructor['subject']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () => _editInstructor(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _deleteInstructor(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToNext,
                child: Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildDropdownField(String label, String? value, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text('Select $label'),
        onChanged: (newValue) {
          setState(() {
            _selectedSubject = newValue;
          });
        },
        items: options.map((subject) {
          return DropdownMenuItem<String>(
            value: subject,
            child: Text(subject),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.subject, color: Colors.deepPurpleAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null ? 'Please select a $label' : null,
      ),
    );
  }
}
