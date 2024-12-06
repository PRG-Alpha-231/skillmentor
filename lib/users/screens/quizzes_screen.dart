import 'package:flutter/material.dart';

class QuizzesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QuizzesScreen'),
        ),
        body: Center(
          child: Text(
            'QuizzesScreen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
