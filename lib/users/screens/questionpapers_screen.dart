import 'package:flutter/material.dart';

class QuestionpapersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QuestionpapersScreen'),
        ),
        body: Center(
          child: Text(
            'QuestionpapersScreen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
