import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillmentor/baseurl.dart' show baseUrl;
import 'package:skillmentor/users/screens/user_login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? instructorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInstructorDetails();
  }

  Future<void> _fetchInstructorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? instructorId = prefs.getString('instructor_id');
    print(instructorId);



    if (instructorId == null) {
      setState(() => isLoading = false);
      return;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/instructor/$instructorId'),
    );

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        instructorData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : instructorData == null
              ? Center(child: Text("No Instructor Data Found"))
              : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Avatar
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: instructorData!["profile_picture"] != null
                ? NetworkImage(instructorData!["profile_picture"])
                : null,
            child: instructorData!["profile_picture"] == null
                ? Icon(Icons.person, size: 60, color: Colors.grey[800])
                : null,
          ),
          SizedBox(height: 20),

          // Name and Role
          Text(
            instructorData!['profile']["username"] ?? "Unknown Instructor",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          SizedBox(height: 8),
          Text(
            instructorData!["qualification"] ?? "No Qualification Available",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 32),

          // Dashboard Section
          _buildDashboardItem(Icons.school, 'Subject', instructorData!['subject']["subject_name"] ?? "N/A", Colors.blue),
          _buildDashboardItem(Icons.email, 'Email', instructorData!['profile']["email"] ?? "N/A", Colors.green),

          // Edit Profile Button
        
         

          // Log Out Button
          SizedBox(height: 16),
          TextButton(
            onPressed: () async{
               SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored preferences

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserLoginScreen()),
      (route) => false, // Removes all previous routes
    );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red, textStyle: TextStyle(fontSize: 16)),
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(IconData icon, String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.2)),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Text(value, style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
