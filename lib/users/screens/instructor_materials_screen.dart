import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class InstructorMaterialsScreen extends StatefulWidget {
  @override
  _InstructorMaterialsScreenState createState() => _InstructorMaterialsScreenState();
}

class _InstructorMaterialsScreenState extends State<InstructorMaterialsScreen> {
  bool _isLoading = false; // Track loading state

  final List<Map<String, String>> materials = [
    // Sample data, it will be replaced by the API response
    {'title': 'Lecture 1 - Introduction to Flutter', 'type': 'PDF', 'url': 'https://example.com/lecture1.pdf'},
    {'title': 'Lecture 2 - Advanced Flutter', 'type': 'PDF', 'url': 'https://example.com/lecture2.pdf'},
  ];

  String _sortBy = 'Title'; // Default sorting by title

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

  Future<void> _addMaterial() async {
    // Step 1: Pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Step 2: Get the selected file and its path
      PlatformFile file = result.files.first;
      String filePath = file.path ?? '';

      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Step 3: Upload the file to the server
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://401d-117-211-183-204.ngrok-free.app/api/add_materials/'),
        );

        // Add the file to the request
        request.files.add(await http.MultipartFile.fromPath('file', filePath));

        // Add other data (if necessary)
        request.fields['name'] = 'testname';
        request.fields['email'] = 'admin@gmail.com';
        request.fields['category'] = 'Materials';

        // Send the request
        var response = await request.send();
        print(response.statusCode);

        if (response.statusCode == 201) {
          // Handle successful API response (e.g., update the materials list)
          print('Material added successfully');
        } else {
          // Handle error response
          print('Failed to add material');
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    } else {
      // User canceled the file picking
      print("File picking canceled");
    }
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
              return ['Title', 'Type'].map((sortOption) {
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
              onPressed: _addMaterial, // Call _addMaterial when button is pressed
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
                    return MaterialCard(material: material);
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

  MaterialCard({required this.material});

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
        trailing: Icon(
          Icons.download,
          color: Colors.blueAccent,
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
