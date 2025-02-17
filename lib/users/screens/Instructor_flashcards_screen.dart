import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InstructorFlashcardsScreen(),
    );
  }
}

class InstructorFlashcardsScreen extends StatefulWidget {
  @override
  _InstructorFlashcardsScreen createState() => _InstructorFlashcardsScreen();
}

class _InstructorFlashcardsScreen extends State<InstructorFlashcardsScreen> {
  int _currentIndex = 0; // Current index of the flashcard
  bool _showAnswer = false; // Track if the answer is visible
  bool _isFlashing = false; // Track flash state

  // List of flashcards
  final List<Map<String, String>> flashcards = [
    {"question": "What is Flutter?", "answer": "A UI toolkit for building natively compiled applications."},
    {"question": "What is Dart?", "answer": "A programming language optimized for building UIs."},
    {"question": "What is a Widget?", "answer": "The basic building block of a Flutter app."},
    {"question": "What is State?", "answer": "State is information that can change during the lifetime of the widget."},
    {"question": "What is Hot Reload?", "answer": "A feature to quickly reload code without restarting the app."},
    {"question": "What is setState?", "answer": "A method to trigger a rebuild of the widget tree."},
    {"question": "What is a Scaffold?", "answer": "A layout structure for a Flutter app."},
    {"question": "What is a MaterialApp?", "answer": "A widget that wraps your app with Material Design."},
    {"question": "What is an AppBar?", "answer": "A widget that represents a toolbar at the top of the screen."},
    {"question": "What is a StatelessWidget?", "answer": "A widget that does not hold mutable state."},
  ];

  // Function to toggle the answer visibility
  void _toggleAnswer() {
    setState(() {
      _isFlashing = true; // Start flash animation
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _showAnswer = !_showAnswer;
        _isFlashing = false; // End flash animation
      });
    });
  }

  // Function to change the current card
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _showAnswer = false; // Reset answer visibility for the new card
    });
  }

  // Function to show dialog box for adding a new flashcard
  void _showAddFlashcardDialog() {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Flashcard"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: "Question"),
              ),
              SizedBox(height: 8),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: "Answer"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String question = questionController.text.trim();
                String answer = answerController.text.trim();

                if (question.isNotEmpty && answer.isNotEmpty) {
                  setState(() {
                    flashcards.add({"question": question, "answer": answer});
                  });
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

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
              onPageChanged: _onPageChanged,
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                return GestureDetector(
                  onTap: _toggleAnswer,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFlashcardDialog,
        backgroundColor: Colors.purpleAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


