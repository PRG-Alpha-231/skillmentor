import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skillmentor/baseurl.dart';
class StudentFlashcardsScreen extends StatefulWidget {
  final String subjectId; // Add subject_id as a parameter

  StudentFlashcardsScreen({required this.subjectId}); // Constructor

  @override
  _StudentFlashcardsScreenState createState() => _StudentFlashcardsScreenState();
}

class _StudentFlashcardsScreenState extends State<StudentFlashcardsScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isFlashing = false;
  List<Map<String, dynamic>> flashcards = [];

  @override
  void initState() {
    super.initState();
    _fetchFlashcards();
  }

  // Fetch flashcards for the specific subject
  Future<void> _fetchFlashcards() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/flashcards/?subject=${widget.subjectId}')); // Filter by subject_id
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          flashcards = data.map<Map<String, dynamic>>((item) => {
            'id': item['id'].toString(),
            'question': item['question'].toString(),
            'answer': item['answer'].toString(),
            'subject_id': item['subject'].toString(), // Include subject_id
          }).toList();
        });
      } else {
        throw Exception('Failed to load flashcards');
      }
    } catch (e) {
      print('Error fetching flashcards: $e');
    }
  }

  // Add a new flashcard for the specific subject
  

  // Update a flashcard
 

  // Delete a flashcard
 
  // Show dialog to add a new flashcard
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flash Cards"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _showAnswer = false; // Reset answer visibility for the new card
                });
              },
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFlashing = true; // Start flash animation
                    });

                    Future.delayed(Duration(milliseconds: 200), () {
                      setState(() {
                        _showAnswer = !_showAnswer;
                        _isFlashing = false; // End flash animation
                      });
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                    width: 250, // Reduced width
                    height: 150, // Reduced height
                    decoration: BoxDecoration(
                      color: _isFlashing ? Colors.lightBlueAccent : Colors.purpleAccent, // Updated colors
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      opacity: _isFlashing ? 0 : 1,
                      duration: Duration(milliseconds: 200),
                      child: Text(
                        _showAnswer ? flashcard['answer']! : flashcard['question']!,
                        style: TextStyle(
                          fontSize: 18, // Adjusted font size
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          // Selector Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              flashcards.length,
                  (index) => AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.purpleAccent : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
      
    );
  }
}