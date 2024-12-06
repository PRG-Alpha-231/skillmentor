import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlashCardScreen(),
    );
  }
}

class FlashCardScreen extends StatefulWidget {
  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  bool _showAnswer = false; // Track if answer is visible
  bool _isFlashing = false; // Track flash state

  // Question and Answer for the flashcard
  final String question = "What is Flutter?";
  final String answer = "A UI toolkit for building natively compiled applications.";

  // Function to toggle answer visibility with flash effect
  void _toggleAnswer() {
    setState(() {
      _isFlashing = true; // Start flash animation
    });

    // Show the answer after a short delay to simulate the flash
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _showAnswer = !_showAnswer;
        _isFlashing = false; // End flash animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flash Card"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleAnswer, // Tap to toggle the answer
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: _isFlashing ? Colors.yellow : Colors.blue, // Flash color
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: _isFlashing ? 0 : 1, // Fade effect during flash
              duration: Duration(milliseconds: 200),
              child: Text(
                _showAnswer ? answer : question,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
