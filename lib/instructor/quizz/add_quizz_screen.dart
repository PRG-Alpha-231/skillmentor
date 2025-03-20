import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skillmentor/baseurl.dart';

class AddQuizScreen extends StatefulWidget {
  @override
  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quizNameController = TextEditingController();
  final _quizDescriptionController = TextEditingController();
  final _questionController = TextEditingController();
  final _optionControllers = List.generate(4, (index) => TextEditingController());
  int? _correctOptionIndex;

  List<Map<String, dynamic>> questions = [];

  void _addQuestion() {
    if (_formKey.currentState!.validate()) {
      final question = {
        'question_text': _questionController.text,
        'options': _optionControllers.map((controller) => controller.text).toList(),
        'correct_option_index': _correctOptionIndex,
      };

      setState(() {
        questions.add(question);
      });

      // Clear fields after adding a question
      _questionController.clear();
      for (var controller in _optionControllers) {
        controller.clear();
      }
      _correctOptionIndex = null;
    }
  }

  Future<void> _submitQuiz() async {
    if (_quizNameController.text.isEmpty || questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one question and a quiz name.')),
      );
      return;
    }

    final quizData = {
      'quiz_name': _quizNameController.text,
      'description': _quizDescriptionController.text,
      'questions': questions,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/quizzes/'), // Replace with your Django backend URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(quizData),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz submitted successfully!')),
      );
      // Clear the form
      _quizNameController.clear();
      _quizDescriptionController.clear();
      setState(() {
        questions.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit quiz. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quiz Name Field
                TextFormField(
                  controller: _quizNameController,
                  decoration: InputDecoration(labelText: 'Quiz Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quiz name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Quiz Description Field
                TextFormField(
                  controller: _quizDescriptionController,
                  decoration: InputDecoration(labelText: 'Quiz Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quiz description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Add Questions Section
                Text('Add Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),

                // Question Field
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(labelText: 'Question'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Options Fields
                ..._optionControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an option';
                            }
                            return null;
                          },
                        ),
                      ),
                      Radio<int>(
                        value: index,
                        groupValue: _correctOptionIndex,
                        onChanged: (value) {
                          setState(() {
                            _correctOptionIndex = value;
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
                SizedBox(height: 20),

              

                // Display Added Questions
                if (questions.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Added Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ...questions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final question = entry.value;
                        return ListTile(
                          title: Text('Q${index + 1}: ${question['question_text']}'),
                          subtitle: Text('Correct Option: ${question['options'][question['correct_option_index']]}'),
                        );
                      }).toList(),
                    ],
                  ),
                SizedBox(height: 20),

                // Submit Quiz Button
                ElevatedButton(
                  onPressed: _submitQuiz,
                  child: Text('Submit Quiz'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}