import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:skillmentor/baseurl.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class StudentQuestionpapersScreen extends StatefulWidget {
  final int subjectId; // Accept subject_id from another page

  StudentQuestionpapersScreen({required this.subjectId});

  @override
  _StudentQuestionpapersScreenState createState() =>
      _StudentQuestionpapersScreenState();
}

class _StudentQuestionpapersScreenState
    extends State<StudentQuestionpapersScreen> {
  List<Map<String, String>> questionPapers = [];
  String _sortBy = 'Title';
  bool _isLoading = false; // For loading indicator

  @override
  void initState() {
    super.initState();
    _fetchQuestionPapers();
  }

  // Fetch question papers by subject_id
  Future<void> _fetchQuestionPapers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/question-papers/${widget.subjectId}/'),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          questionPapers = data.map<Map<String, String>>((item) => {
            'id': item['id'].toString(),
            'title': item['title'].toString(),
            'year': item['year'].toString(),
            'url': '$baseUrl/api${item['file']}', // Prepend the base URL
          }).toList();
          print(questionPapers);
        });
      } else {
        throw Exception('Failed to load question papers');
      }
    } catch (e) {
      print('Error fetching question papers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching question papers: $e')),
      );
    }
  }

  // Sort question papers by title or year
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

  // Pick a file and upload it
  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      _showAddDetailsDialog(selectedFile); // Show pop-up for details
    }
  }

  // Show pop-up dialog to add title and year
  void _showAddDetailsDialog(File file) {
    TextEditingController titleController = TextEditingController();
    TextEditingController yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Question Paper Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title')),
              TextField(
                controller: yearController,
                decoration: InputDecoration(labelText: 'Year')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await _uploadFile(
                  file,
                  titleController.text,
                  yearController.text,
                ); // Upload file with details
              },
              child: Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  // Upload the selected file to the backend
  Future<void> _uploadFile(File file, String title, String year) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/add-question-paper/'),
      );
      request.fields['title'] = title; // Add title from dialog
      request.fields['year'] = year; // Add year from dialog
      request.fields['subject'] = widget.subjectId.toString(); // Add subject_id
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload Successful!'), backgroundColor: Colors.green),
        );
        // Refresh the list after upload
        _fetchQuestionPapers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload Failed!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Delete a question paper
  Future<void> _deleteQuestionPaper(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/delete-question-paper/$id/'),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted Successfully!'), backgroundColor: Colors.green),
        );
        // Refresh the list after deletion
        _fetchQuestionPapers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Delete!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting file: $e'), backgroundColor: Colors.red),
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: questionPapers.length,
              itemBuilder: (context, index) {
                final paper = questionPapers[index];
                return QuestionPaperCard(
                  paper: paper,
                  onDelete: () => _deleteQuestionPaper(int.parse(paper['id']!)),
                );
              },
              separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
              physics: BouncingScrollPhysics(),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(), // Show loading indicator
            ),
        ],
      ),
     
    );
  }
}

// Widget to display a question paper card
class QuestionPaperCard extends StatelessWidget {
  final Map<String, String> paper;
  final VoidCallback onDelete;

  QuestionPaperCard({required this.paper, required this.onDelete});

  // Function to launch the PDF URL
  Future<void> _launchPdfUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            IconButton(
              icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
              onPressed: () => {
                 _launchPdfUrl(paper['url']!),
              },
            ),
          ],
        ),
      ),
    );
  }
}