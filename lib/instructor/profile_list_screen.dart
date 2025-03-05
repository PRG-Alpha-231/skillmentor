import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skillmentor/baseurl.dart'; // Replace with your base URL

class ProfileListScreen extends StatefulWidget {
  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  List<dynamic> profiles = [];
  bool isLoading = false;

  Future<void> fetchProfiles() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch profiles with the role "User"
      final url = Uri.parse('$baseUrl/profiles/?role=User');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          profiles = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load profiles: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles with Role "User"'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : profiles.isEmpty
              ? Center(child: Text('No profiles found', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
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
                        subtitle: Text(
                          'Role: ${profile['role'] ?? 'No Role'}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
                        onTap: () {
                          // Handle profile tap (e.g., navigate to details screen)
                        },
                      ),
                    );
                  },
                ),
    );
  }
}