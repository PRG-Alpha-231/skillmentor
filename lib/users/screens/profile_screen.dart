import 'package:flutter/material.dart';
import 'package:skillmentor/users/screens/resource_screen.dart';
import 'package:skillmentor/users/screens/user_home.dart';
import 'package:skillmentor/users/screens/edit_profile_screen.dart'; // Import the EditProfileScreen
import 'package:skillmentor/users/screens/user_login_screen.dart'; // Import the UserLoginScreen

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Main profile content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: Center(
                      child: Icon(Icons.person, size: 60, color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Name and Title
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  // The "text" should match the Course title set by the admin/Instructor
                  Text(
                    'BCA Student', // "text"
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Dashboard Section
                  _buildDashboardItem(
                    Icons.access_time,
                    'Time Spent',
                    'Total time to be shown Here',
                    Colors.amber,
                  ),

                  // Edit Profile Button (TextButton with no background)
                  SizedBox(height: 32), // Add some spacing before the button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue, // Text color (foreground)
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text('Edit Profile'),
                  ),

                  // Log Out Button
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserLoginScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red, // Text color for Log Out
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text('Log Out'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Profile tab is active
        selectedItemColor: Colors.grey[700], // Soft gray for selected item
        unselectedItemColor: Colors.grey[500], // Lighter gray for unselected items
        backgroundColor: Colors.white, // White background for the bottom navigation
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserHome()));
              break;
            case 1:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ResourcesScreen()));
              break;
            case 2:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              break;
          }
        },
      ),
    );
  }

  // Build Dashboard Item
  Widget _buildDashboardItem(IconData icon, String title, String badge, Color badgeColor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badgeColor.withOpacity(0.2),
            ),
            child: Icon(icon, color: badgeColor),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          if (badge.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
