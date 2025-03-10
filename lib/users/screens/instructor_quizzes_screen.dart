import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillmentor/baseurl.dart';


class QuizService {

  static Future<Map<String, dynamic>> addQuizQuestionPaper(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/AddQuizQuestionPaper/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add quiz question paper');
    }
  }

  static Future<Map<String, dynamic>> addQuestions(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_questions/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add questions');
    }
  }
}




































class InstructorQuizzesScreen extends StatefulWidget {
  @override
  _InstructorQuizzesScreenState createState() => _InstructorQuizzesScreenState();
}

class _InstructorQuizzesScreenState extends State<InstructorQuizzesScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  int score = 0;

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        isAnswered = false;
        selectedAnswer = null;
      }
    });
  }


  void showAddQuizDialog() {
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  String? selectedCorrectAnswer;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add New Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: questionController, decoration: InputDecoration(labelText: 'Enter question')),
              TextField(controller: option1Controller, decoration: InputDecoration(labelText: 'Option 1')),
              TextField(controller: option2Controller, decoration: InputDecoration(labelText: 'Option 2')),
              TextField(controller: option3Controller, decoration: InputDecoration(labelText: 'Option 3')),
              TextField(controller: option4Controller, decoration: InputDecoration(labelText: 'Option 4')),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Correct Answer'),
                items: [option1Controller, option2Controller, option3Controller, option4Controller]
                    .map((controller) => DropdownMenuItem(
                  value: controller.text,
                  child: Text(controller.text.isEmpty ? 'Option' : controller.text),
                ))
                    .toList(),
                onChanged: (value) => selectedCorrectAnswer = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newQuestion = {
                'question': questionController.text,
                'options': [
                  option1Controller.text,
                  option2Controller.text,
                  option3Controller.text,
                  option4Controller.text,
                ],
                'answer': selectedCorrectAnswer ?? '',
              };

              // Add the question to the backend
              try {
                // Explicitly cast newQuestion['options'] to List<String>
                List<String> options = newQuestion['options'] as List<String>;

                await QuizService.addQuestions({
                  'paper_id': 1, // Replace with the actual paper ID
                  'question': newQuestion['question'],
                  'option_a': options[0],
                  'option_b': options[1],
                  'option_c': options[2],
                  'option_d': options[3],
                  'correct_answer': newQuestion['answer'],
                });

                setState(() {
                  questions.add(newQuestion);
                });
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add question: $e')),
                );
              }
            },
            child: Text('Add Quiz'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz App')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  questions[currentQuestionIndex]['question'],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions[currentQuestionIndex]['options'].length,
                itemBuilder: (context, index) {
                  String option = questions[currentQuestionIndex]['options'][index];
                  return Card(
                    color: selectedAnswer == option ? Colors.blue.shade100 : Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(option, style: TextStyle(fontSize: 18)),
                      leading: Radio(
                        value: option,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            selectedAnswer = value as String?;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: nextQuestion,
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              child: Text('Next Question'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddQuizDialog,
        icon: Icon(Icons.add),
        label: Text('Add Quiz'),
      ),
    );
  }
}