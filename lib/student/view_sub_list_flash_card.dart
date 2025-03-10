import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skillmentor/baseurl.dart';
import 'package:skillmentor/student/view_flash_cards.dart';
import 'package:skillmentor/users/screens/Instructor_flashcards_screen.dart';

class SfSubjectListScreen extends StatefulWidget {
  @override
  _SfSubjectListScreenState createState() => _SfSubjectListScreenState();
}

class _SfSubjectListScreenState extends State<SfSubjectListScreen> {
  bool _isLoading = true;
  List<dynamic> materials = [];

  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/materials/'));
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          materials = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load materials');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final subject = materials[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentFlashcardsScreen(subjectId: subject['subject'].toString(),),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Icon or Image
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.book,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 16),
                          // Subject Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject['name']??'',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  subject['description'] ?? 'No description',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Arrow Icon
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}