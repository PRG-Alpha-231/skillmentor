import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skillmentor/baseurl.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<dynamic> endUsers = [];
  bool isLoading = false;

  Future<void> fetchEndUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch only users with the role "User"
      final url = Uri.parse('$baseUrl/ListEndUsers?role=User');
      final response = await http.get(url);
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          endUsers = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load end users: ${response.body}');
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
    fetchEndUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('End Users'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : endUsers.isEmpty
              ? Center(child: Text('No users found', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: endUsers.length,
                  itemBuilder: (context, index) {
                    final user = endUsers[index];
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
                            user['email'][0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          user['email'] ?? 'No Email',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          user['role'] ?? 'No Role',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
                        onTap: () {
                          // Handle user tap (e.g., navigate to details screen)
                        },
                      ),
                    );
                  },
                ),
    );
  }
}