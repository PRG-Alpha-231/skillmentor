import 'package:flutter/material.dart';


import 'admin.dart';

class AddInstituteScreen extends StatefulWidget {
  @override
  _AddInstituteScreenState createState() => _AddInstituteScreenState();
}

class _AddInstituteScreenState extends State<AddInstituteScreen> {
  final TextEditingController _instituteNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Institute'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _instituteNameController,
              decoration: InputDecoration(
                labelText: "Institute Name *",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description (Optional)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AdminApp()),
                  // );
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
    );
  }
}
