import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:skillmentor/baseurl.dart';
import 'package:skillmentor/users/screens/add_subjects.dart';

class SubjectListScreen extends StatefulWidget {
  @override
  _SubjectListScreenState createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  List<dynamic> allSubjects = []; // Store all subjects fetched from the API
  List<dynamic> filteredSubjects = []; // Store subjects filtered by institute_id
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/subjects/'),
        headers: {'Content-Type': 'application/json'},
      );


      print(Uri.parse('$baseUrl/api/subjects/'),);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allSubjects = data; // Store all subjects
          filterSubjectsByInstitute(); // Filter subjects by institute_id
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> filterSubjectsByInstitute() async {
    // Get institute_id from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final instituteId = prefs.getString('institute_id');
    print(instituteId);

    if (instituteId != null) {
     
      setState(() {
        filteredSubjects = allSubjects.where((subject) {
          final department = subject['department'];
          final institute = department['institute'];
          return institute.toString() == instituteId;
        }).toList();
      });
    } else {
      // If institute_id is not found, show all subjects
      setState(() {
        filteredSubjects = allSubjects;
      });
    }
  }

  Future<void> deleteSubject(int subjectId) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/subjects/$subjectId/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 204) {
      // If the subject is deleted successfully, refresh the list
      fetchSubjects();
    } else {
      throw Exception('Failed to delete subject');
    }
  } catch (e) {
    setState(() {
      errorMessage = e.toString();
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchSubjects,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSubjectScreen()),
          ).then((value){
            fetchSubjects();
          },);
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : errorMessage.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $errorMessage',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: fetchSubjects,
                          child: Text('Retry', style: TextStyle(color: Colors.deepPurple)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                        ),
                      ],
                    )
                  : filteredSubjects.isEmpty
                      ? Text(
                          'No subjects found for this institute',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      : filteredSubjects.isEmpty ? Center(child: Text('No subjects'),)  : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: filteredSubjects.length,
                          itemBuilder: (context, index) {
                            final subject = filteredSubjects[index];
                            final department = subject['department'];
                            

                            return Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.book, color: Colors.deepPurple),
                                title: Text(
                                  subject['subject_name'] ?? 'No Name',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subject['description'] ?? 'No Description',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Department: ${department['name']}',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Show a confirmation dialog before deleting
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Subject'),
                                        content: Text('Are you sure you want to delete this subject?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Close the dialog
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context); // Close the dialog
                                              await deleteSubject(subject['id']); // Delete the subject
                                            },
                                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}