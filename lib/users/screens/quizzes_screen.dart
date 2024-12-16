import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizzesScreen(),
    );
  }
}

class QuizzesScreen extends StatefulWidget {
  @override
  _QuizzesScreenState createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  // List of questions and options (10 questions)
  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is Flutter?',
      'options': ['A programming language', 'A UI toolkit', 'An IDE', 'A game engine'],
      'answer': 'A UI toolkit',
    },
    {
      'question': 'What is Dart?',
      'options': ['A programming language', 'A database', 'A UI framework', 'A web browser'],
      'answer': 'A programming language',
    },
    {
      'question': 'Which company created Flutter?',
      'options': ['Google', 'Microsoft', 'Apple', 'Amazon'],
      'answer': 'Google',
    },
    {
      'question': 'What is the default programming language for Flutter?',
      'options': ['JavaScript', 'Dart', 'Kotlin', 'Swift'],
      'answer': 'Dart',
    },
    {
      'question': 'Which widget is the root of all Flutter apps?',
      'options': ['MaterialApp', 'Scaffold', 'Center', 'Container'],
      'answer': 'MaterialApp',
    },
    {
      'question': 'What is the use of the "build" method in Flutter?',
      'options': ['To create the layout of the app', 'To fetch data', 'To handle user input', 'To manage state'],
      'answer': 'To create the layout of the app',
    },
    {
      'question': 'Which of the following is not a valid Flutter widget?',
      'options': ['Text', 'Row', 'List', 'Column'],
      'answer': 'List',
    },
    {
      'question': 'What does "pubspec.yaml" file do in Flutter?',
      'options': ['Defines project dependencies', 'Handles app state', 'Manages UI layout', 'Contains images and assets'],
      'answer': 'Defines project dependencies',
    },
    {
      'question': 'Which Flutter feature helps with building adaptive UIs?',
      'options': ['Widgets', 'Layouts', 'Themes', 'Responsive design'],
      'answer': 'Responsive design',
    },
    {
      'question': 'What is the purpose of "hot reload" in Flutter?',
      'options': ['To reload the app without losing state', 'To update dependencies', 'To reset the app', 'To perform a clean build'],
      'answer': 'To reload the app without losing state',
    },
  ];

  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  bool isCorrect = false;
  int score = 0;

  // Disable button state after answer is checked
  bool isCheckAnswerClicked = false;

  // Function to move to the next question
  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        isAnswered = false; // Reset for the next question
        selectedAnswer = null;
        isCheckAnswerClicked = false; // Enable buttons again for the next question
      }
    });
  }

  // Function to check if the selected answer is correct
  void checkAnswer() {
    if (selectedAnswer == null) return;

    setState(() {
      isAnswered = true;
      isCorrect = selectedAnswer == questions[currentQuestionIndex]['answer'];

      if (isCorrect) {
        score++;
      }
      isCheckAnswerClicked = true; // Disable the Check Answer button
    });
  }

  // Common button style
  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF6200EE), // Purple button color
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      textStyle: TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      minimumSize: Size(double.infinity, 50), // Ensures consistent button height
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz',
          style: TextStyle(color: Colors.white), // Make title text white
        ),
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Color(0xFF3700B3), // A deep purple for the app bar
        iconTheme: IconThemeData(color: Colors.white), // Make back arrow white
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Updated Question Section
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Text(
                  currentQuestion['question'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Dark text color for better readability
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Options Section
            Expanded(
              flex: 3, // Allow space for the options
              child: ListView.builder(
                itemCount: currentQuestion['options'].length,
                itemBuilder: (context, index) {
                  String option = currentQuestion['options'][index];
                  return GestureDetector(
                    onTap: () {
                      if (!isCheckAnswerClicked) {
                        setState(() {
                          selectedAnswer = option;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(18),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            selectedAnswer == option
                                ? (isAnswered
                                ? (isCorrect ? Colors.green : Colors.red)
                                : Color(0xFF6200EE)) // Purple gradient for selected answer
                                : Color(0xFFEDE7F6), // Lighter color for unselected options
                            selectedAnswer == option
                                ? (isAnswered
                                ? (isCorrect ? Colors.green[600]! : Colors.red[600]!)
                                : Color(0xFF3700B3)) // Darker purple gradient when answered
                                : Color(0xFFD1C4E9), // Soft lavender for unselected
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: selectedAnswer == option
                                ? Colors.white
                                : Colors.black87, // White text when selected
                          ),
                          textAlign: TextAlign.center, // Center text horizontally
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Repositioned buttons
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  if (!isAnswered && !isCheckAnswerClicked)
                    ElevatedButton(
                      onPressed: checkAnswer,
                      style: buttonStyle(),
                      child: Text(
                        'Check Answer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  SizedBox(height: 15),
                  if (isAnswered && currentQuestionIndex < questions.length - 1)
                    ElevatedButton(
                      onPressed: nextQuestion,
                      style: buttonStyle(),
                      child: Text('Next Question', style: TextStyle(color: Colors.white)),
                    ),
                  if (currentQuestionIndex == questions.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Quiz Completed', style: TextStyle(color: Colors.black)),
                              content: Text('Your score: $score/${questions.length}', style: TextStyle(color: Colors.black)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      score = 0;
                                      currentQuestionIndex = 0;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text('Restart Quiz', style: TextStyle(color: Colors.black)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuizzesScreen()));
                                  },
                                  child: Text('Exit', style: TextStyle(color: Colors.black)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: buttonStyle(),
                      child: Text('End Quiz', style: TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
