import 'package:flutter/material.dart';



class FlashCardScreen extends StatefulWidget {
  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flash Cards"),
        backgroundColor: Colors.blueAccent,
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
                      color: _isFlashing ? Colors.lightBlueAccent : Colors.blueAccent, // New colors
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
