import 'package:flutter/material.dart';
import 'add_instructor.dart';
import 'add_subjects.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Map<String, String>> instructors = [];
  List<Map<String, String>> subjects = [];

  void _editInstructor(int index) {
    final instructor = instructors[index];
    TextEditingController nameController = TextEditingController(text: instructor['name']);
    TextEditingController emailController = TextEditingController(text: instructor['email']);
    TextEditingController subjectController = TextEditingController(text: instructor['subject']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Instructor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameController, 'Name'),
            _buildTextField(emailController, 'Email'),
            _buildTextField(subjectController, 'Subject'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                instructors[index] = {
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'subject': subjectController.text.trim(),
                };
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteInstructor(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Instructor'),
        content: Text('Are you sure you want to delete this instructor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                instructors.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _deleteSubject(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Subject'),
        content: Text('Are you sure you want to delete this subject?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                subjects.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSection('Instructors', instructors, true),
            SizedBox(height: 20),
            _buildSection('Subjects', subjects, false),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addInstructor',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddInstructorScreen()));
            },
            child: Icon(Icons.person_add),
            backgroundColor: Colors.deepPurple,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'addSubject',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddSubjectScreen()));
            },
            child: Icon(Icons.book),
            backgroundColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> items, bool isInstructor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(item['name'] ?? ''),
                    subtitle: Text(isInstructor
                        ? 'Email: ${item['email']} \nSubject: ${item['subject']}'
                        : 'Code: ${item['code']} \nDescription: ${item['description']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _editInstructor(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => isInstructor ? _deleteInstructor(index) : _deleteSubject(index),
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}