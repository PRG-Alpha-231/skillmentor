import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillmentor/baseurl.dart';
import 'package:http/http.dart' as http;
import 'package:skillmentor/users/screens/user_login_screen.dart';
 // UserLogin screen

class ApiService {

  // Fetch admin profile by ID
  static Future<Map<String, dynamic>> fetchAdminProfile(String adminId) async {

    print(adminId);
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/profile/test6@gmail.com/'),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load admin profile');
    }
  }
}
    

 // UserLogin screen

class AdminProfileScreen extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Map<String, dynamic>? adminProfile;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAdminProfile();
  }

  Future<void> fetchAdminProfile() async {
    try {
      // Get admin email from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
      final adminId = prefs.getString('admin_email');
     
      // Fetch admin profile from the backend
      final profile = await ApiService.fetchAdminProfile(adminId!);
      setState(() {
        adminProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    // Clear admin email from SharedPreferences

    // Navigate to UserLogin screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: logout,
          ),
        ],
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
                          onPressed: fetchAdminProfile,
                          child: Text('Retry', style: TextStyle(color: Colors.deepPurple)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                        ),
                      ],
                    )
                  : Card(
                      margin: EdgeInsets.all(20),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 50,
                             child: Icon(Icons.person, size: 50, color: Colors.white),
                            ),
                            SizedBox(height: 20),
                            _buildProfileField(Icons.person, 'ID', adminProfile!['id'].toString()),
                            _buildProfileField(Icons.email, 'Email', adminProfile!['email']),
                            _buildProfileField(Icons.people, 'Username', adminProfile!['username']),
                            _buildProfileField(Icons.work, 'Role', adminProfile!['role']),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildProfileField(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}