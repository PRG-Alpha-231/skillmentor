import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PDFAnalyzerPage extends StatefulWidget {
  @override
  _PDFAnalyzerPageState createState() => _PDFAnalyzerPageState();
}

class _PDFAnalyzerPageState extends State<PDFAnalyzerPage> {
  File? _selectedFile;
  bool _isUploading = false;
  String? _extractedText;
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (_selectedFile == null) {
        _showFileSelectionDialog();
      }
    });
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
      _uploadPDF();
    }
  }

  Future<void> _uploadPDF() async {
    if (_selectedFile == null) {
      _showFileSelectionDialog();
      return;
    }

    setState(() {
      _isUploading = true;
      _extractedText = null;
    });

    var request = http.MultipartRequest('POST', Uri.parse('https://your-api-url.com/upload-pdf'));
    request.files.add(await http.MultipartFile.fromPath('uploaded_pdf', _selectedFile!.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = json.decode(await response.stream.bytesToString());
      setState(() {
        _extractedText = responseData['extracted_text'];
        _showChat = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload PDF')));
    }

    setState(() {
      _isUploading = false;
    });
  }

  void _showFileSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a PDF'),
          content: Text('Please select a PDF file to analyze.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickPDF();
              },
              child: Text('Choose File'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Analyzer')),
      body: Center(
        child: _showChat
            ? ChatScreen(extractedText: _extractedText!)
            : _isUploading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Uploading and analyzing your PDF...')
          ],
        )
            : ElevatedButton(
          onPressed: _pickPDF,
          child: Text('Pick PDF File'),
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String extractedText;
  ChatScreen({required this.extractedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with PDF')),
      body: Center(
        child: Text('Chatbot Interface for PDF Analysis Goes Here'),
      ),
    );
  }
}