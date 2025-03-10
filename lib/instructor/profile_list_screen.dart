import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skillmentor/baseurl.dart';
import 'package:skillmentor/instructor/instructor_add_student.dart';
import 'package:skillmentor/instructor/instructor_add_student_screen.dart'; // Replace with your base URL

class ProfileListScreen extends StatefulWidget {
  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  List<dynamic> profiles = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  /// Fetch Profiles
  Future<void> fetchProfiles() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = Uri.parse('$baseUrl/api/profiles/?role=User');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          profiles = data;
        });
      } else {
        throw Exception('Failed to load profiles: ${response.body}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Delete Student API Call
 Future<void> _deleteStudent(int profileId) async {
  setState(() {
    isLoading = true;
  });

  try {
    final url = Uri.parse('$baseUrl/api/StudentUpdateProfile/?Profile_id=$profileId');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile deleted successfully!')),
      );
      fetchProfiles(); // Refresh the list after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete profile: ${response.body}')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  /// Show Profile Details Dialog
  void _showProfileDetails(BuildContext context, Map<String, dynamic> profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profile['first_name'] ?? 'No First Name'} ${profile['last_name'] ?? 'No Last Name'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Email: ${profile['email'] ?? 'No Email'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Role: ${profile['role'] ?? 'No Role'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Active: ${profile['is_active'] ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Close', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  void _navigateToAddProfileScreen(BuildContext context) {
  // Navigate to a new screen where you can add a new profile
  // For now, we'll just show a placeholder SnackBar
   Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => IAddStudentScreen()),
  );
  
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profiles with Role "User"'),
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: fetchProfiles,
        ),
      ],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
        : errorMessage.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage, style: TextStyle(fontSize: 16, color: Colors.red)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: fetchProfiles,
                      child: Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : profiles.isEmpty
                ? Center(
                    child: Text('No profiles found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];

                      print(profile);
                      final studentId = profile['id']; // Extract student ID

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              profile['email'][0].toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            profile['email'] ?? 'No Email',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Role: ${profile['role'] ?? 'No Role'}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              SizedBox(height: 5),
                              Text('Name: ${profile['first_name'] ?? 'No First Name'} ${profile['last_name'] ?? 'No Last Name'}',
                                  style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text('Active: ${profile['is_active'] ?? 'Unknown'}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              _deleteStudent(studentId); // Call delete function
                            },
                            child: Icon(Icons.delete, size: 30, color: Colors.red),
                          ),
                          onTap: () {
                            _showProfileDetails(context, profile);
                          },
                        ),
                      );
                    },
                  ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _navigateToAddProfileScreen(context),
      child: Icon(Icons.add, color: Colors.white),
      backgroundColor: Colors.blueAccent,
    ),
  );
}




}
