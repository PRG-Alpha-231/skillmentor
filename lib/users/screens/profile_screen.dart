import 'package:flutter/material.dart';
import 'package:skillmentor/users/screens/resource_screen.dart';
import 'package:skillmentor/users/screens/user_home.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/user_profile.jpg'), // Add your image here
              ),
              SizedBox(height: 16),

              // User Name
              Text(
                'Jane Doe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // User Email
              Text(
                'jane.doe@example.com',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),

              // User Details
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.phone, color: Colors.blue),
                  title: Text('+1 123 456 7890'),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.location_on, color: Colors.red),
                  title: Text('New York, USA'),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.work, color: Colors.green),
                  title: Text('Software Engineer at XYZ Inc.'),
                ),
              ),

              SizedBox(height: 24),

              // Edit Profile Button
              ElevatedButton.icon(
                onPressed: () {
                  // Action for editing the profile
                  print('Edit Profile Button Clicked');
                },
                icon: Icon(Icons.edit),
                label: Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,  // Set to ProfileScreen as default
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserHome()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResourcesScreen()),
              );
              break;
            case 2:
            // No need to navigate for the Profile screen, it is already active
              break;
          }
        },
      ),
    );
  }
}
