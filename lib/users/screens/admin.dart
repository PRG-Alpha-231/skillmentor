import 'package:flutter/material.dart';
import 'package:skillmentor/baseurl.dart';
import 'AdminHomeScreen.dart';
import 'add_institute.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_subjects.dart'; // Ensure that add_subjects.dart is properly imported
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'AdminHomeScreen.dart';

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> loginAdmin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final String apiUrl = "$baseUrl/api/login";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data["access"];
      final refreshToken = data["refresh"];
      final role = data["role"];

      if (role == "ADMIN") {
        // Save tokens for future authentication
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", accessToken);
        await prefs.setString("refresh_token", refreshToken);

        // Navigate to Admin Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
      } else {
        setState(() {
          errorMessage = "You are not authorized as an Admin.";
        });
      }
    } else {
      setState(() {
        errorMessage = "Invalid email or password.";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text("Admin Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              if (errorMessage != null) ...[
                SizedBox(height: 10),
                Text(errorMessage!, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: loginAdmin,
                child: Text("Login"),
              ),
              SizedBox(height: 20),

              // Sign Up Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text("New to SkillMentor? Sign Up"),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}




class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> registerAdmin() async {
    setState(() {
      _isLoading = true;
    });

    // API Endpoint
    const String url = "$baseUrl/api/AdminRegistration/";

    // Request Body
    Map<String, dynamic> requestData = {
      "username": _usernameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      print(response.body);

      if (response.statusCode == 200) {
        // Successful Registration
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['msg'])),
        );

        // Navigate to Add Institute Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddInstituteScreen()),
        );
      } else {
        // Handle Errors
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${errorData.toString()}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Error: $e")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text("Get Started", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username *"),
              ),
              SizedBox(height: 10),

              // Admin Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Admin Email *"),
              ),
              SizedBox(height: 10),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password *"),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // Register Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: _isLoading ? null : registerAdmin,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Register"),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
