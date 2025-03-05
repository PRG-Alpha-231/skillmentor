import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:skillmentor/baseurl.dart';

class InstructorMaterialsScreen extends StatefulWidget {
  @override
  _InstructorMaterialsScreenState createState() => _InstructorMaterialsScreenState();
}

class _InstructorMaterialsScreenState extends State<InstructorMaterialsScreen> {
  bool _isLoading = false; // Track loading state

  List<Map<String, String>> materials = []; // List to store fetched materials
  List<Map<String, dynamic>> subjects = []; // List to store fetched subjects

  String _sortBy = 'Title'; // Default sorting by title

  @override
  void initState() {
    super.initState();
    _fetchMaterials(); // Fetch materials
    _fetchSubjects(); // Fetch subjects
  }

  Future<void> _fetchMaterials() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/materials/'));
      print(Uri.parse('$baseUrl/api/materials/'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);
        print(data);

        // Update the materials list
        setState(() {
          materials.clear();
          materials.addAll(data.map<Map<String, String>>((item) => {
                'id': item['id'].toString(), // Add material ID
                'title': item['name'] as String,
                'type': item['category'] as String,
                'url': item['file'] as String,
                'description': item['description'] ?? 'ss', // Add description
              }));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch materials')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _fetchSubjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/subjects/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        print(data);

        setState(() {
          subjects = data.map<Map<String, dynamic>>((subject) => {
                'id': subject['id'] as int,
                'name': subject['subject_name'] as String,
              }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch subjects')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _sortMaterials(String criterion) {
    setState(() {
      if (criterion == 'Title') {
        materials.sort((a, b) => a['title']!.compareTo(b['title']!));
      } else if (criterion == 'Type') {
        materials.sort((a, b) => a['type']!.compareTo(b['type']!));
      }
      _sortBy = criterion; // Update the sort criterion
    });
  }

  Future<void> _showAddMaterialDialog() async {
    // Controllers for text fields
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    String? selectedSubject; // Selected subject from dropdown

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Material'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedSubject,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                  items: subjects.map<DropdownMenuItem<String>>((subject) {
                    return DropdownMenuItem<String>(
                      value: subject['id'].toString(),
                      child: Text(subject['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubject = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                // Validate inputs
                if (nameController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    selectedSubject == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                // Close the dialog
                Navigator.of(context).pop();

                // Call the method to add material
                await _addMaterial(
                  name: nameController.text,
                  description: descriptionController.text,
                  category: categoryController.text,
                  subjectId: selectedSubject!,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addMaterial({
    required String name,
    required String description,
    required String category,
    required String subjectId,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      Uint8List? fileBytes = file.bytes; // Get file bytes directly

      if (fileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to read file')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/api/add_materials/'),
        );

        // Add the file using fromBytes
        request.files.add(http.MultipartFile.fromBytes(
          'file', // Field name in the API
          fileBytes, // File bytes
          filename: file.name, // File name
        ));

        // Add other fields
        request.fields['name'] = name;
        request.fields['description'] = description;
        request.fields['category'] = category;
        request.fields['subject'] = subjectId;

        // Send the request
        var response = await request.send();

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Material added successfully')),
          );
          _fetchMaterials(); // Refresh the materials list after adding
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add material')),
          );
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File picking canceled')),
      );
    }
  }

  Future<void> _updateMaterial(String materialId, Map<String, String> updatedData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/update_materials/?materials_id=$materialId'),
      );

      // Add updated fields
      request.fields['name'] = updatedData['title']!;
      request.fields['description'] = updatedData['description']!;
      request.fields['category'] = updatedData['type']!;

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Material updated successfully')),
        );
        _fetchMaterials(); // Refresh the materials list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update material')),
        );
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

  Future<void> _deleteMaterial(String materialId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await http.delete(
        Uri.parse('$baseUrl/update_materials/?materials_id=$materialId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Material deleted successfully')),
        );
        _fetchMaterials(); // Refresh the materials list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete material')),
        );
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

  Future<void> _showUpdateMaterialDialog(Map<String, String> material) async {
    final TextEditingController nameController = TextEditingController(text: material['title']);
    final TextEditingController descriptionController = TextEditingController(text: material['description']);
    final TextEditingController categoryController = TextEditingController(text: material['type']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Material'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateMaterial(
                  material['id']!,
                  {
                    'title': nameController.text,
                    'description': descriptionController.text,
                    'type': categoryController.text,
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Materials'),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortMaterials,
            itemBuilder: (context) {
              return ['Title', 'Type'].map<PopupMenuItem<String>>((sortOption) {
                return PopupMenuItem<String>(
                  value: sortOption,
                  child: Text(sortOption),
                );
              }).toList();
            },
            icon: Icon(Icons.sort),
            tooltip: 'Sort by',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showAddMaterialDialog, // Show the pop-up dialog
              child: Text('Add Material'),
            ),
            if (_isLoading) // Show loading indicator while waiting
              Center(child: CircularProgressIndicator()),
            if (!_isLoading) // Display materials when not loading
              Expanded(
                child: ListView.separated(
                  itemCount: materials.length,
                  itemBuilder: (context, index) {
                    final material = materials[index];
                    return MaterialCard(
                      material: material,
                      onUpdate: () => _showUpdateMaterialDialog(material),
                      onDelete: () => _deleteMaterial(material['id']!),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
                  physics: BouncingScrollPhysics(), // Smooth scrolling with bounce effect
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MaterialCard extends StatelessWidget {
  final Map<String, String> material;
  final Function onUpdate;
  final Function onDelete;

  MaterialCard({
    required this.material,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      shadowColor: Colors.grey.shade400,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        title: Text(
          material['title']!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          'Type: ${material['type']}',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'update') {
              onUpdate();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'update',
              child: Text('Update'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          icon: Icon(Icons.more_vert, color: Colors.blueAccent),
        ),
        onTap: () {
          _openMaterial(context, material['url']!);
        },
      ),
    );
  }

  void _openMaterial(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Open Material',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Would you like to view or download this material?',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            child: Text('View', style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              print('View the material at $url');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Download', style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              print('Download the material from $url');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}