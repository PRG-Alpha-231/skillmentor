import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillmentor/baseurl.dart';
import 'dart:convert';
import 'package:skillmentor/instructor/Material/update_material_screen.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class UserMaterialScreen extends StatefulWidget {
  @override
  _UserMaterialScreenState createState() => _UserMaterialScreenState();
}

class _UserMaterialScreenState extends State<UserMaterialScreen> {
  List<dynamic> materials = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.get(Uri.parse('$baseUrl/api/materials/'));
    if (response.statusCode == 200) {
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
  }

  Future<void> _refreshMaterials() async {
    await fetchMaterials();
  }

  Future<void> _launchPdf(String fileUrl) async {
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      throw 'Could not launch $fileUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materials List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : materials.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 50, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No materials found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchMaterials,
                        child: Text('Refresh'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshMaterials,
                  child: ListView.builder(
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      final material = materials[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.description, color: Colors.blueAccent),
                                  SizedBox(width: 8),
                                  Text(
                                    material['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Category: ${material['category']}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  _launchPdf('$baseUrl/api'+ material['file']);
                                },
                                child: Text(
                                  'File: ${material['file']}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
                                    onPressed: () {
                                                                        _launchPdf('$baseUrl/api'+ material['file']);

                                     
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}