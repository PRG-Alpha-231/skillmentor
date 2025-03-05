import 'package:flutter/material.dart';
import 'package:skillmentor/instructor/profile_list_screen.dart';
import 'package:skillmentor/instructor/users_list_screen.dart';
import 'package:skillmentor/users/screens/profile_screen.dart';
import 'instructor_resource_screen.dart';

class InstructorHomeScreen extends StatefulWidget {
  @override
  _InstructorHomeScreenState createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    ProfileListScreen(),
    InstructorResourceScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}