import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:skillmentor/baseurl.dart';
import 'package:skillmentor/users/screens/add_departments.dart';

class DepartmentListScreen extends StatefulWidget {
  DepartmentListScreen();

  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  List<dynamic> departments = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final instituteId = prefs.getString('institute_id');
      final response = await http.get(
        Uri.parse('$baseUrl/api/institutes/$instituteId/departments/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          departments = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deleteDepartment(int departmentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/update_Department/?Department_id=$departmentId'),
        headers: {'Content-Type': 'application/json'},
      );



      print(response.body);
      if (response.statusCode == 200) {
        // If the department is deleted successfully, refresh the list
        fetchDepartments();
      } else {
        throw Exception('Failed to delete department');
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
        title: Text('Departments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchDepartments,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddDepartments())).then((value) {
            fetchDepartments();
          });
        },
      ),
      body: Container(
        decoration: BoxDecoration(),
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
                          onPressed: fetchDepartments,
                          child: Text('Retry', style: TextStyle(color: Colors.deepPurple)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                        ),
                      ],
                    )
                  : departments.isEmpty
                      ? Text(
                          'No departments found',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: departments.length,
                          itemBuilder: (context, index) {
                            final department = departments[index];
                            return Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.school, color: Colors.deepPurple),
                                title: Text(
                                  department['name'] ?? 'No Name',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  department['description'] ?? 'No Description',
                                  style: TextStyle(fontSize: 14),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Show a confirmation dialog before deleting
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Department'),
                                        content: Text('Are you sure you want to delete this department?'),
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
                                              await deleteDepartment(department['id']); // Delete the department
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