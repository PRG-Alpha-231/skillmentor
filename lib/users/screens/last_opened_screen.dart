import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Last Opened Screen',
      home: LastOpenedScreen(),
    );
  }
}

class LastOpenedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last Opened Screen'),
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
