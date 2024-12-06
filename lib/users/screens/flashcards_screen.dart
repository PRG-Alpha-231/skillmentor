import 'package:flutter/material.dart';

class FlashcardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FlashcardsScreen'),
        ),
        body: Center(
          child: Text(
            'FlashcardsScreen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
