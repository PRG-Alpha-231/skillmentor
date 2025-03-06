import 'package:flutter/material.dart';
import 'package:skillmentor/admin/admin_profile_screen.dart';
import 'package:skillmentor/admin/list_all_department.dart';
import 'package:skillmentor/admin/list_all_subject.dart' show SubjectListScreen;
import 'package:skillmentor/instructor/all_instructores_view.dart';
import 'package:skillmentor/instructor/instructor_add_student.dart';
import 'package:skillmentor/instructor/profile_list_screen.dart';
import 'add_departments.dart';
import 'add_instructor.dart';
import 'add_subjects.dart';


class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DepartmentListScreen(),
    SubjectListScreen(),
    InstructorListScreen(),
    ProfileListScreen(),
    AdminProfileScreen(),
  ];

  @override

  Widget build(BuildContext context) {
    return Scaffold(

      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Departments'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Subjects'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Instructors'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
