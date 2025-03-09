import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

import 'package:skillmentor/baseurl.dart'; // For JSON parsing

class AddMaterialsScreen extends StatefulWidget {
  const AddMaterialsScreen({super.key});

  @override
  _AddMaterialsScreenState createState() => _AddMaterialsScreenState();
}

class _AddMaterialsScreenState extends State<AddMaterialsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  File? _file;
  List<Subject> _subjects = [];
  int? _selectedSubjectId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSubjects(context);
  }

  Future<void> _fetchSubjects(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/subjects/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _subjects = data.map((subject) => Subject.fromJson(subject)).toList();
          });
        }
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load subjects: $e', context);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      if (mounted) {
        setState(() {
          _file = File(result.files.single.path!);
        });
      }
    } else {
      _showErrorSnackBar('No file selected', context);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _file != null && _selectedSubjectId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await AddMaterialsService.addMaterial(
          name: _nameController.text,
          description: _descriptionController.text,
          category: _categoryController.text,
          file: _file!,
          subjectId: _selectedSubjectId!,
        );

        _showSuccessSnackBar('Material added successfully!', context);
        Navigator.pop(context);
      } catch (e) {
        _showErrorSnackBar('Failed to add material: $e', context);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      _showErrorSnackBar('Please fill all fields and select a file', context);
    }
  }

  void _showErrorSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Materials'),
        backgroundColor: Colors.blue, // Blue theme for AppBar
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.blue.shade50, // Light blue background
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.blue.shade50, // Light blue background
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.blue.shade50, // Light blue background
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: _selectedSubjectId,
                        decoration: InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.blue.shade50, // Light blue background
                        ),
                        items: _subjects.map((subject) {
                          return DropdownMenuItem<int>(
                            value: subject.id,
                            child: Text(subject.subjectName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubjectId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a subject';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _file == null
                          ? SizedBox(
                              width: double.infinity, // Full-width button
                              child: ElevatedButton.icon(
                                onPressed: _pickFile,
                                icon: Icon(Icons.upload_file, color: Colors.white),
                                label: Text('Pick File', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.blue, // Blue button
                                ),
                            ))
                          : Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.file_present, color: Colors.blue),
                                  title: Text('File selected: ${path.basename(_file!.path)}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.change_circle, color: Colors.blue),
                                    onPressed: _pickFile,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity, // Full-width button
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Submit', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.blue, // Blue button
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class AddMaterialsService {
  static const String _baseUrl = baseUrl; // Replace with your Django server URL

  static Future<void> addMaterial({
    required String name,
    required String description,
    required String category,
    required File file,
    required int subjectId,
  }) async {
    var uri = Uri.parse('$_baseUrl/api/add_materials/');
    var request = http.MultipartRequest('POST', uri);

    // Add text fields
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['category'] = category;
    request.fields['subject'] = subjectId.toString();

    // Add file
    var stream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: path.basename(file.path),
    );
    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to upload materials. Status code: ${response.statusCode}');
    }
  }
}

class Subject {
  final int id;
  final String subjectName;
  final String? description;

  Subject({required this.id, required this.subjectName, this.description});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      subjectName: json['subject_name'],
      description: json['description'],
    );
  }
}