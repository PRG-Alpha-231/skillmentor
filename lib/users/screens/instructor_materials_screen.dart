import 'package:flutter/material.dart';

class InstructorMaterialsScreen extends StatefulWidget {
  @override
  _InstructorMaterialsScreenState createState() => _InstructorMaterialsScreenState();
}

class _InstructorMaterialsScreenState extends State<InstructorMaterialsScreen> {
  // Extended sample data for course materials (can be fetched dynamically from an API)
  final List<Map<String, String>> materials = [
    {'title': 'Lecture 1 - Introduction to Flutter', 'type': 'PDF', 'url': 'https://example.com/lecture1.pdf'},
    {'title': 'Lecture 2 - Advanced Flutter', 'type': 'PDF', 'url': 'https://example.com/lecture2.pdf'},
    {'title': 'Homework 1 - Basic Flutter Quiz', 'type': 'PDF', 'url': 'https://example.com/homework1.pdf'},
    {'title': 'Project Guidelines', 'type': 'Word Document', 'url': 'https://example.com/project_guidelines.docx'},
    {'title': 'Research Paper on Flutter', 'type': 'PDF', 'url': 'https://example.com/research_paper.pdf'},
    {'title': 'Course Syllabus', 'type': 'PowerPoint', 'url': 'https://example.com/syllabus.pptx'},
    {'title': 'Lecture Notes - Data Structures', 'type': 'PDF', 'url': 'https://example.com/data_structures_notes.pdf'},
    {'title': 'Lecture Notes - Algorithms', 'type': 'PDF', 'url': 'https://example.com/algorithms_notes.pdf'},
    {'title': 'Assignment - Flutter UI', 'type': 'Word Document', 'url': 'https://example.com/flutter_ui_assignment.docx'},
    {'title': 'Course Evaluation Form', 'type': 'PDF', 'url': 'https://example.com/course_evaluation.pdf'},
    {'title': 'Midterm Exam Review', 'type': 'PDF', 'url': 'https://example.com/midterm_review.pdf'},
    {'title': 'Final Exam Study Guide', 'type': 'PDF', 'url': 'https://example.com/final_exam_study_guide.pdf'},
    {'title': 'Lecture Slides - Introduction to Programming', 'type': 'PowerPoint', 'url': 'https://example.com/intro_programming_slides.pptx'},
    {'title': 'Lecture 5 - Network Protocols', 'type': 'PDF', 'url': 'https://example.com/network_protocols_lecture.pdf'},
    {'title': 'Lecture 6 - Databases and SQL', 'type': 'PDF', 'url': 'https://example.com/databases_sql_lecture.pdf'},
    {'title': 'Course Feedback Survey', 'type': 'PDF', 'url': 'https://example.com/course_feedback.pdf'},
    {'title': 'Instructor Contact Information', 'type': 'PDF', 'url': 'https://example.com/instructor_contact.pdf'},
    {'title': 'Code Samples for Flutter', 'type': 'GitHub Repository', 'url': 'https://github.com/example/flutter_code_samples'},
    {'title': 'Flutter Debugging Tips', 'type': 'PDF', 'url': 'https://example.com/flutter_debugging_tips.pdf'},
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

  // Function to handle uploading new materials
  void _uploadMaterial() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Upload New Material'),
        content: UploadMaterialForm(),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
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
        child: ListView.separated(
          itemCount: materials.length,
          itemBuilder: (context, index) {
            final material = materials[index];
            return MaterialCard(material: material);
          },
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
          physics: BouncingScrollPhysics(),  // Smooth scrolling with bounce effect
        ),
      ),
      // Floating Action Button for uploading new material
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadMaterial,  // Calls the upload function when pressed
        child: Icon(Icons.add),       // Plus icon
        tooltip: 'Upload Material',   // Tooltip when hovered over
        backgroundColor: Colors.blueAccent,  // Background color of the button
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

class UploadMaterialForm extends StatefulWidget {
  @override
  _UploadMaterialFormState createState() => _UploadMaterialFormState();
}

class _UploadMaterialFormState extends State<UploadMaterialForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Field
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Material Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the material title';
              }
              return null;
            },
          ),
          SizedBox(height: 8),

          // Type Field
          TextFormField(
            controller: _typeController,
            decoration: InputDecoration(
              labelText: 'Material Type',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the material type (e.g., PDF, Word)';
              }
              return null;
            },
          ),
          SizedBox(height: 8),

          // URL Field
          TextFormField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: 'Material URL',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the material URL';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Submit Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle the form submission logic here
                final title = _titleController.text;
                final type = _typeController.text;
                final url = _urlController.text;

                // Example: Show a dialog with submitted information
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('New Material Uploaded'),
                    content: Text('Title: $title\nType: $type\nURL: $url'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('Upload'),
          ),
        ],
      ),
    );
  }
}
