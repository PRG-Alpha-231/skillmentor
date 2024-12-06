import 'package:flutter/material.dart';

class QuestionpapersScreen extends StatefulWidget {
  @override
  _QuestionpapersScreenState createState() => _QuestionpapersScreenState();
}

class _QuestionpapersScreenState extends State<QuestionpapersScreen> {
  // Extended sample data for question papers (PDF only) with Year information
  final List<Map<String, String>> questionPapers = [
    {'title': 'Midterm Exam - Fall 2025', 'url': 'https://example.com/midterm_exam_fall_2025.pdf', 'year': '2025'},
    {'title': 'Final Exam - Spring 2025', 'url': 'https://example.com/final_exam_spring_2025.pdf', 'year': '2025'},
    {'title': 'Midterm Exam - Fall 2024', 'url': 'https://example.com/midterm_exam_fall_2024.pdf', 'year': '2024'},
    {'title': 'Final Exam - Spring 2024', 'url': 'https://example.com/final_exam_spring_2024.pdf', 'year': '2024'},
    {'title': 'Midterm Review - Java Programming', 'url': 'https://example.com/midterm_review_java.pdf', 'year': '2024'},
    {'title': 'Final Exam - Data Structures', 'url': 'https://example.com/final_exam_data_structures.pdf', 'year': '2024'},
    {'title': 'Midterm Exam - Fall 2023', 'url': 'https://example.com/midterm_exam_fall_2023.pdf', 'year': '2023'},
    {'title': 'Final Exam - Spring 2023', 'url': 'https://example.com/final_exam_spring_2023.pdf', 'year': '2023'},
    {'title': 'Midterm Review - Web Development', 'url': 'https://example.com/midterm_review_webdev.pdf', 'year': '2022'},
    {'title': 'Final Exam - Algorithms and Data Structures', 'url': 'https://example.com/final_exam_algorithms.pdf', 'year': '2022'},
    {'title': 'Midterm Exam - Fall 2022', 'url': 'https://example.com/midterm_exam_fall_2022.pdf', 'year': '2022'},
    {'title': 'Final Exam - Web Development', 'url': 'https://example.com/final_exam_webdev.pdf', 'year': '2021'},
    {'title': 'Midterm Exam - Spring 2021', 'url': 'https://example.com/midterm_exam_spring_2021.pdf', 'year': '2021'},
    {'title': 'Final Exam - Software Engineering', 'url': 'https://example.com/final_exam_software_engineering.pdf', 'year': '2021'},
    {'title': 'Midterm Exam - Database Systems', 'url': 'https://example.com/midterm_exam_database_systems.pdf', 'year': '2021'},
    {'title': 'Final Exam - Network Security', 'url': 'https://example.com/final_exam_network_security.pdf', 'year': '2020'},
    {'title': 'Midterm Exam - Fall 2020', 'url': 'https://example.com/midterm_exam_fall_2020.pdf', 'year': '2020'},
    {'title': 'Final Exam - Operating Systems', 'url': 'https://example.com/final_exam_operating_systems.pdf', 'year': '2020'},
  ];

  String _sortBy = 'Title'; // Default sorting by title

  // Function to sort by title or year
  void _sortQuestionPapers(String criterion) {
    setState(() {
      if (criterion == 'Title') {
        questionPapers.sort((a, b) => a['title']!.compareTo(b['title']!));
      } else if (criterion == 'Year') {
        questionPapers.sort((a, b) => int.parse(b['year']!).compareTo(int.parse(a['year']!)));
      }
      _sortBy = criterion; // Update the sort criterion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question Papers',
          style: TextStyle(color: Colors.grey[800]), // Dark gray text for a subtle professional look
        ),
        backgroundColor: Colors.grey[200], // Soft neutral beige-gray for a calm, professional vibe
        elevation: 2.0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortQuestionPapers,
            itemBuilder: (context) {
              return ['Title', 'Year'].map((sortOption) {
                return PopupMenuItem<String>(
                  value: sortOption,
                  child: Text(sortOption, style: TextStyle(color: Colors.grey[800])),
                );
              }).toList();
            },
            icon: Icon(Icons.sort, color: Colors.grey[800]), // Matching icon color for consistency
            tooltip: 'Sort by',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: questionPapers.length,
          itemBuilder: (context, index) {
            final paper = questionPapers[index];
            return QuestionPaperCard(paper: paper);
          },
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
          physics: BouncingScrollPhysics(),  // Smooth scrolling with bounce effect
        ),
      ),
    );
  }
}

class QuestionPaperCard extends StatelessWidget {
  final Map<String, String> paper;

  QuestionPaperCard({required this.paper});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white, // Clean white background for professionalism
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        title: Text(
          paper['title']!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Dark gray text for professional feel
          ),
        ),
        subtitle: Text(
          'Year: ${paper['year']}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600, // Subtle gray for the year
          ),
        ),
        trailing: Icon(
          Icons.download,
          color: Colors.blueGrey[600], // Professional icon color
        ),
        onTap: () {
          _openPaper(context, paper['url']!);
        },
      ),
    );
  }

  void _openPaper(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Open Question Paper',
          style: TextStyle(
            color: Colors.blueGrey[600], // Matching title with icon color
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Would you like to view or download this question paper?',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            child: Text('View', style: TextStyle(color: Colors.blueGrey[600])), // Button color matched with title
            onPressed: () {
              print('View the question paper at $url');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Download', style: TextStyle(color: Colors.blueGrey[600])), // Button color matched with title
            onPressed: () {
              print('Download the question paper from $url');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
