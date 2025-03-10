import 'package:flutter/material.dart';
import 'package:skillmentor/baseurl.dart';
import 'package:skillmentor/users/screens/instructor_home_screen.dart';
import 'package:skillmentor/users/screens/user_home.dart';
import 'package:skillmentor/users/screens/user_registration_screen.dart';
import 'package:skillmentor/users/screens/forgot_password_screen.dart'; //

import 'admin.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  late String email, password;
  String? emailError, passwordError;
  bool showPassword = false;
  bool isLoading = false; // To show a loading indicator

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();
    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    bool isValid = true;

    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'Email is invalid';
      });
      isValid = false;
    }

    if (password.isEmpty || password.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 8 characters';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    if (!validate()) return;

    setState(() {
      isLoading = true;
    });

    const String apiUrl = "$baseUrl/api/login"; // Replace with your actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", data["access"]);
        await prefs.setString("refresh_token", data["refresh"]);
        await prefs.setString("user_role", data["role"]);

        // Navigate based on role
        if (data["role"] == "admin") {
          Navigator.pushReplacementNamed(context, "/adminHome");
        } else if (data["role"] == "Instructor") {
          print('lllll');
        await prefs.setString("instructor_id", data["instructor_id"].toString());

         
         Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>  InstructorHomeScreen(),) , (route) => false,);
        } else {
                  await prefs.setString("student_id", data["student_id"].toString());

          print(data);

              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>  UserHome(),) , (route) => false,);

        }
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData["detail"] ?? "Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error connecting to server")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: screenHeight * .12),
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.7)),
              ),
              SizedBox(height: screenHeight * .12),

              InputField(
                labelText: 'Email',
                errorText: emailError,
                onChanged: (value) => setState(() => email = value),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autoFocus: true,
              ),
              SizedBox(height: screenHeight * .025),

              InputField(
                labelText: 'Password',
                errorText: passwordError,
                obscureText: !showPassword,
                onChanged: (value) => setState(() => password = value),
                onSubmitted: (_) => login(),
                textInputAction: TextInputAction.done,

              ),
              SizedBox(height: screenHeight * .03),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () => Navigator.pushNamed(context, "/forgotPassword"),
              //     child: const Text('Forgot Password?', style: TextStyle(color: Colors.black)),
              //   ),
              // ),

              isLoading
                  ? const CircularProgressIndicator()
                  : FormButton(text: 'Login', onPressed: login),
              SizedBox(height: screenHeight * .15),

              TextButton(
                onPressed: () =>     Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminApp()),
                ),
                child: RichText(
                  text: const TextSpan(
                    text: "Not a user, ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(color: Color.fromARGB(255, 3, 6, 148), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

