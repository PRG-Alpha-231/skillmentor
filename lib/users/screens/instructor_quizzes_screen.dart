import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: InstructorQuizzesScreen(),
    );
  }
}

class InstructorQuizzesScreen extends StatefulWidget {
  @override
  _InstructorQuizzesScreenState createState() => _InstructorQuizzesScreenState();
}

class _InstructorQuizzesScreenState extends State<InstructorQuizzesScreen> {
  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is Flutter?',
      'options': ['A programming language', 'A UI toolkit', 'An IDE', 'A game engine'],
      'answer': 'A UI toolkit',
    },
  ];

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
              onPressed: () {
                setState(() {
                  questions.add({
                    'question': questionController.text,
                    'options': [
                      option1Controller.text,
                      option2Controller.text,
                      option3Controller.text,
                      option4Controller.text,
                    ],
                    'answer': selectedCorrectAnswer ?? '',
                  });
                });
                Navigator.pop(context);
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


