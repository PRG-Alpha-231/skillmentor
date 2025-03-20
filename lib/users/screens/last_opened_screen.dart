import 'package:flutter/material.dart';





class LastOpenedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last Opened Screen'),
      ),
      body: Center(
        child: Text('Most recently accessed content'),
      ),
    );
  }
}
