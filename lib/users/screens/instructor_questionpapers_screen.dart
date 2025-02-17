import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class InstructorQuestionpapersScreen extends StatefulWidget {
  @override
  _InstructorQuestionpapersScreenState createState() =>
      _InstructorQuestionpapersScreenState();
}

class _InstructorQuestionpapersScreenState
    extends State<InstructorQuestionpapersScreen> {
  final List<Map<String, String>> questionPapers = [
    {'title': 'Midterm Exam - Fall 2025', 'url': 'https://example.com/midterm_exam_fall_2025.pdf', 'year': '2025'},
    {'title': 'Final Exam - Spring 2025', 'url': 'https://example.com/final_exam_spring_2025.pdf', 'year': '2025'},
    {'title': 'Midterm Exam - Fall 2024', 'url': 'https://example.com/midterm_exam_fall_2024.pdf', 'year': '2024'},
    {'title': 'Final Exam - Spring 2024', 'url': 'https://example.com/final_exam_spring_2024.pdf', 'year': '2024'},
  ];

  String _sortBy = 'Title';

  void _sortQuestionPapers(String criterion) {
    setState(() {
      if (criterion == 'Title') {
        questionPapers.sort((a, b) => a['title']!.compareTo(b['title']!));
      } else if (criterion == 'Year') {
        questionPapers.sort((a, b) => int.parse(b['year']!).compareTo(int.parse(a['year']!)));
      }
      _sortBy = criterion;
    });
  }

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      await _uploadFile(selectedFile);
    }
  }

  Future<void> _uploadFile(File file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:8000/api/add_materials/'));
      request.fields['name'] = 'Uploaded File';
      request.fields['description'] = 'Uploaded via Flutter';
      request.fields['category'] = 'Exam Papers';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload Successful!'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload Failed!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Papers', style: TextStyle(color: Colors.grey[800])),
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
        onPressed: _pickAndUploadFile,
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Text(
          'Year: ${paper['year']}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        trailing: Icon(Icons.download, color: Colors.blueGrey[600]),
      ),
    );
  }
}
