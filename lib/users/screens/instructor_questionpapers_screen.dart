import 'package:flutter/material.dart';

class InstructorQuestionpapersScreen extends StatefulWidget {
  @override
  _InstructorQuestionpapersScreenState createState() =>
      _InstructorQuestionpapersScreenState();
}

class _InstructorQuestionpapersScreenState
    extends State<InstructorQuestionpapersScreen> {
  // Extended sample data for question papers (PDF only) with Year information
  final List<Map<String, String>> questionPapers = [
    {'title': 'Midterm Exam - Fall 2025', 'url': 'https://example.com/midterm_exam_fall_2025.pdf', 'year': '2025'},
    {'title': 'Final Exam - Spring 2025', 'url': 'https://example.com/final_exam_spring_2025.pdf', 'year': '2025'},
    {'title': 'Midterm Exam - Fall 2024', 'url': 'https://example.com/midterm_exam_fall_2024.pdf', 'year': '2024'},
    {'title': 'Final Exam - Spring 2024', 'url': 'https://example.com/final_exam_spring_2024.pdf', 'year': '2024'},
    // Add more question papers here...
  ];

  String _sortBy = 'Title'; // Default sorting by title

  // Function to sort by title or year
  void _sortQuestionPapers(String criterion) {
    setState(() {
      if (criterion == 'Title') {
        questionPapers.sort((a, b) => a['title']!.compareTo(b['title']!));
      } else if (criterion == 'Year') {
        questionPapers.sort((a, b) => int.parse(b['year']!).compareTo(int.parse(a['year']!)));
      }
      _sortBy = criterion; // Update the sort criterion
    });
  }

  // Function to handle the "Add New Question Paper" action
  void _addNewQuestionPaper() {
    // Show the Upload Material Form as a modal bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return UploadMaterialForm();
      },
      isScrollControlled: true,  // Allows for a more flexible height for the modal
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question Papers',
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 2.0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortQuestionPapers,
            itemBuilder: (context) {
              return ['Title', 'Year'].map((sortOption) {
                return PopupMenuItem<String>(
                  value: sortOption,
                  child: Text(sortOption, style: TextStyle(color: Colors.grey[800])),
                );
              }).toList();
            },
            icon: Icon(Icons.sort, color: Colors.grey[800]),
            tooltip: 'Sort by',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: questionPapers.length,
          itemBuilder: (context, index) {
            final paper = questionPapers[index];
            return QuestionPaperCard(paper: paper);
          },
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
          physics: BouncingScrollPhysics(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewQuestionPaper,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[600],
        tooltip: 'Add New Question Paper',
      ),
    );
  }
}

class QuestionPaperCard extends StatelessWidget {
  final Map<String, String> paper;

  QuestionPaperCard({required this.paper});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        title: Text(
          paper['title']!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          'Year: ${paper['year']}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          Icons.download,
          color: Colors.blueGrey[600],
        ),
        onTap: () {
          _openPaper(context, paper['url']!);
        },
      ),
    );
  }

  void _openPaper(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Open Question Paper',
          style: TextStyle(
            color: Colors.blueGrey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Would you like to view or download this question paper?',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            child: Text('View', style: TextStyle(color: Colors.blueGrey[600])),
            onPressed: () {
              print('View the question paper at $url');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Download', style: TextStyle(color: Colors.blueGrey[600])),
            onPressed: () {
              print('Download the question paper from $url');
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Material Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100], // Light background for input
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the material title';
                }
                return null;
              },
            ),
            SizedBox(height: 12),

            // Type Field
            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Material Type (e.g., PDF)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100], // Light background for input
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the material type';
                }
                return null;
              },
            ),
            SizedBox(height: 12),

            // URL Field
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Material URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100], // Light background for input
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
                  // Handle form submission logic here
                  final title = _titleController.text;
                  final type = _typeController.text;
                  final url = _urlController.text;

                  // Example: Show a dialog with submitted information
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(
                        'New Material Uploaded',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[600],
                        ),
                      ),
                      content: Text(
                        'Title: $title\nType: $type\nURL: $url',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('OK', style: TextStyle(color: Colors.blueGrey[600])),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[600], // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
