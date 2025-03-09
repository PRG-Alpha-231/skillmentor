import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:skillmentor/baseurl.dart';

class UpdateMaterialScreen extends StatefulWidget {
  final int materialId;
  final String materialName;
  final String materialDescription;
  final String materialCategory;

  UpdateMaterialScreen({
    required this.materialId,
    required this.materialName,
    required this.materialDescription,
    required this.materialCategory,
  });

  @override
  _UpdateMaterialScreenState createState() => _UpdateMaterialScreenState();
}

class _UpdateMaterialScreenState extends State<UpdateMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  File? _file;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with passed data
    _nameController = TextEditingController(text: widget.materialName);
    _descriptionController = TextEditingController(text: widget.materialDescription);
    _categoryController = TextEditingController(text: widget.materialCategory);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/api/update_materials/?materials_id=${widget.materialId}'),
        );
        request.fields['name'] = _nameController.text;
        request.fields['description'] = _descriptionController.text;
        request.fields['category'] = _categoryController.text;

        // Add file if selected
        if (_file != null) {
          request.files.add(
            await http.MultipartFile.fromPath('file', _file!.path),
          );
        }

        final response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Material updated successfully')),
          );
          Navigator.pop(context); // Return to the previous screen
        } else {
          throw Exception('Failed to update material. Status code: ${response.statusCode}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Material', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update Material Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _categoryController,
                      label: 'Category',
                      icon: Icons.category,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _file == null
                        ? ElevatedButton.icon(
                            onPressed: _pickFile,
                            icon: Icon(Icons.upload_file),
                            label: Text('Upload File'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          )
                        : Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.file_present, color: Colors.blueAccent),
                                title: Text('file'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _file = null;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: Icon(Icons.update),
                        label: Text('Update Material'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}