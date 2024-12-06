import 'package:flutter/material.dart';

class WhiteboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WhiteboardScreen'),
        ),
        body: Center(
          child: Text(
            'WhiteboardScreen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
