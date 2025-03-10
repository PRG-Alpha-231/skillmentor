import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skillmentor/baseurl.dart';
import 'package:skillmentor/users/screens/resource_screen.dart';
import 'package:skillmentor/users/screens/user_home.dart';
import 'package:skillmentor/users/screens/user_login_screen.dart';

class SProfileScreen extends StatefulWidget {
  @override
  _SProfileScreenState createState() => _SProfileScreenState();
}

class _SProfileScreenState extends State<SProfileScreen> {
  Map<String, dynamic>? studentProfile;
  bool isLoading = true;
  String? studentId;

  @override
  void initState() {
    super.initState();
    fetchStudentIdAndProfile();
  }

  Future<void> fetchStudentIdAndProfile() async {
    // Retrieve student ID from SharedPreferences
    studentId = await getStudentId();
    if (studentId != null) {
      await fetchStudentProfile(studentId!);
    } else {
      // Handle case where student ID is not found
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchStudentProfile(String studentId) async {
    print(studentId);
    final response = await http.get(
      Uri.parse('$baseUrl/api/StudentUpdateProfile/?student_id=$studentId'),
    );

    print(      Uri.parse('$baseUrl/api/StudentUpdateProfile/?student_id=$studentId')
    
);
print(response.body);

    if (response.statusCode == 201) {
      setState(() {
        studentProfile = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<String?> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('student_id');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('student_id'); // Clear the student ID
    await prefs.clear();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserLoginScreen()), (route) => false,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : studentProfile == null
              ? Center(child: Text('No profile data found'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: Icon(Icons.person, size: 60),
                      ),
                      SizedBox(height: 20),
                      Text(
                        studentProfile!['profile']['username'] ?? 'No Name',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        studentProfile!['profile']['email'] ?? 'No Email',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Icon(Icons.school, color: Colors.blue),
                          title: Text('Course'),
                          subtitle: Text(studentProfile!['department_name'] ?? 'No Course'),
                        ),
                      ),
                     
                      
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome()));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResourcesScreen()));
              break;
            case 2:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}