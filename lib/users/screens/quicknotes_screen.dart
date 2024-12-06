import 'package:flutter/material.dart';

class QuicknotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QuicknotesScreen'),
        ),
        body: Center(
          child: Text(
            'QuicknotesScreen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
