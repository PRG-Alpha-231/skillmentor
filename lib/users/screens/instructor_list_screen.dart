import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillmentor/baseurl.dart';
import 'package:skillmentor/users/screens/add_instructor.dart';

class InstructorListScreen extends StatefulWidget {
  @override
  _InstructorListScreenState createState() => _InstructorListScreenState();
}

class _InstructorListScreenState extends State<InstructorListScreen> {
  List<Map<String, dynamic>> instructors = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInstructors();
  }

  Future<void> _fetchInstructors() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/instructors/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          instructors = List<Map<String, dynamic>>.from(data);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load instructors: ${response.body}')),
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

  Future<void> _deleteInstructor(String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.delete(Uri.parse('$baseUrl/api/instructors/$id/'));
      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Instructor deleted successfully!')),
        );
        _fetchInstructors(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete instructor: ${response.body}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructors', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : instructors.isEmpty
              ? Center(child: Text('No instructors found.', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: instructors.length,
                  itemBuilder: (context, index) {
                    final instructor = instructors[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurpleAccent,
                          child: Text(
                            instructor['profile']['email'][0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          instructor['profile']['email'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Subject: ${instructor['subject']['subject_name']}'),
                            Text('Qualification: ${instructor['qualification']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteInstructor(instructor['id'].toString()),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Instructor Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddInstructorScreen()),
          ).then((_) => _fetchInstructors()); // Refresh the list after adding
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}