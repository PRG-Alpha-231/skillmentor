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
    final response = await http.get(
      Uri.parse('$baseUrl/admin/profile/$adminId/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load admin profile');
    }
  }
}



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
      // Get admin ID from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
      final adminId = prefs.getString('admin_id');
      if (adminId == null) {
        throw Exception('Admin ID not found');
      }

      // Fetch admin profile from the backend
      final profile = await ApiService.fetchAdminProfile(adminId);
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
    // Clear admin ID from SharedPreferences
   
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
        title: Text('Admin Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage', style: TextStyle(color: Colors.red)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${adminProfile!['id']}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Email: ${adminProfile!['email']}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Username: ${adminProfile!['username']}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Role: ${adminProfile!['role']}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Institute: ${adminProfile!['institute'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
    );
  }
}