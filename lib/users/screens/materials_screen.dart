import 'package:flutter/material.dart';

class MaterialsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MaterialsScreen'),
        ),
        body: Center(
          child: Text(
            'MaterialsScreen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
