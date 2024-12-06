import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
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
            // Resource 1
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.link, color: Colors.blue),
                title: Text('Flutter Documentation'),
                subtitle: Text('Official Flutter documentation for developers.'),
                onTap: () {
                  // Action on tap, e.g., open a link
                  print('Navigate to Flutter Documentation');
                },
              ),
            ),
            // Resource 2
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.video_library, color: Colors.green),
                title: Text('Dart Programming Tutorials'),
                subtitle: Text('Beginner to advanced tutorials on Dart.'),
                onTap: () {
                  // Action on tap, e.g., open a video tutorial
                  print('Navigate to Dart Programming Tutorials');
                },
              ),
            ),
            // Resource 3
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.book, color: Colors.orange),
                title: Text('Introduction to Flutter'),
                subtitle: Text('Learn the basics of Flutter development.'),
                onTap: () {
                  // Action on tap, e.g., open a downloadable file
                  print('Navigate to Introduction to Flutter');
                },
              ),
            ),
            // Resource 4
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.article, color: Colors.red),
                title: Text('Flutter Blog'),
                subtitle: Text('Stay updated with the latest Flutter news.'),
                onTap: () {
                  // Action on tap, e.g., open a blog link
                  print('Navigate to Flutter Blog');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
