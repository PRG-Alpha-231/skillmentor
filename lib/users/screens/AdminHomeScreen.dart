import 'package:flutter/material.dart';
import 'add_departments.dart';
import 'add_instructor.dart';
import 'add_subjects.dart';
import 'admin_profile.dart';
import 'admin_users.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AddDepartments(),
    AddSubjectScreen(),
    AddInstructorScreen(),
    AdminUsersPage(),
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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Screen'));
  }
}



class InstructorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instructors')),
      body: Center(child: Text('Instructors Screen')),
    );
  }
}

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Center(child: Text('Users Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Screen')),
    );
  }
}
