import 'package:flutter/material.dart';
import 'package:skillmentor/instructor/Material/list_material.dart';
import 'package:skillmentor/instructor/flash_card/list_subject.dart';
import 'package:skillmentor/instructor/quizz/add_quizz_screen.dart';
import 'package:skillmentor/instructor/qustion_paper/qustion_paper_list_sub.dart';
import 'package:skillmentor/users/screens/quicknotes_screen.dart';
import 'package:skillmentor/users/screens/whiteboard_screen.dart';

import 'instructor_quizzes_screen.dart';

class InstructorResourceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomResourceCard(
              title: "Materials",
              description: "Comprehensive learning materials to help you understand key concepts and practices.",
              bgColor: Color(0xFFAEDBFF), // Brighter pastel blue
              icon: Icons.book, // Book icon for resources/materials
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialsListScreen()));
              },
            ),
            SizedBox(height: 16),
            CustomResourceCard(
              title: "QuickNotes",
              description: "Quickly jot down ideas, reminders, or important information with minimal effort.",
              bgColor: Color(0xFFB2F2BB), // Brighter pastel green
              icon: Icons.note, // Note icon for notes
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => QuickNotesScreen()));
              },
            ),
            SizedBox(height: 16),
            CustomResourceCard(
              title: "Whiteboard",
              description: "Interactive whiteboard for brainstorming and visualizing ideas and concepts.",
              bgColor: Color(0xFFFFE7B9), // Brighter pastel orange
              icon: Icons.sticky_note_2, // Sticky note icon for whiteboard
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WhiteboardScreen()));
              },
            ),
            SizedBox(height: 16),
            CustomResourceCard(
              title: "Quizzes",
              description: "Test your knowledge with quizzes.",
              bgColor: Color(0xFFFFC4C4), // Brighter pastel red
              icon: Icons.quiz, // Quiz icon for quizzes
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuizScreen()));
              },
            ),
            SizedBox(height: 16),
            CustomResourceCard(
              title: "Flashcards",
              description: "Interactive flashcards for quick review of key terms and concepts.",
              bgColor: Color(0xFFB2E1FF), // Brighter pastel light blue
              icon: Icons.flash_on, // Flash icon for flashcards
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorSubjectListScreen()));
              },
            ),
            SizedBox(height: 16),
            CustomResourceCard(
              title: "Question Papers",
              description: "Access previous question papers to help you prepare for exams and tests.",
              bgColor: Color(0xFFF1D1F7), // Brighter pastel purple
              icon: Icons.description, // File icon for question papers
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorQSubjectListScreen()));
              },
            ),
          ],
        ),
      ),
   
    );
  }
}

// Custom Card Widget
class CustomResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final Color bgColor;
  final IconData icon;
  final VoidCallback onTap;

  CustomResourceCard({
    required this.title,
    required this.description,
    required this.bgColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.black54), // Resource-specific icon
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
