import 'package:flutter/material.dart';
import 'package:skillmentor/baseurl.dart';
import 'AdminHomeScreen.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillmentor/baseurl.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';




// ------------------------------ LOGIN PAGE ------------------------------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  bool _obscureText = true; // For toggling password visibility

  // Validation for email
  String? validateEmail(String? email) {
   
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email!)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Validation for password
  String? validatePassword(String? password) {
  
    if (password!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("token", data["access"]);

      final role = data["role"];

      if (role == "Admin") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await pref.setString("admin_email", emailController.text);
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
              // Email TextField with validation
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: validateEmail(emailController.text),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              // Password TextField with validation and show/hide functionality
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: validatePassword(passwordController.text),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
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
                      onPressed: () {
                        // Only attempt login if email and password are valid
                        if (validateEmail(emailController.text) == null &&
                            validatePassword(passwordController.text) == null) {
                          loginAdmin();
                        } else {
                          setState(() {
                            errorMessage = "Please fix the errors above.";
                          });
                        }
                      },
                      child: Text("Login"),
                    ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
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
  final TextEditingController _instituteNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void dispose() {
    _instituteNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> registerAdmin() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if the form is invalid
    }

    setState(() {
      _isLoading = true;
    });

    const String url = "$baseUrl/api/AdminRegistration/";

    Map<String, dynamic> requestData = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestData);
      print(response.statusCode);

      if (response.statusCode == 200) {
        
        final responseData = jsonDecode(response.body);
        print(responseData);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("admin_id", responseData['admin']['id'].toString());

        await addInstitute();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['msg'])));

        Navigator.pop(context);
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${errorData.toString()}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Network Error: $e")));
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> addInstitute() async {
    const String instituteUrl = "$baseUrl/api/add_institute/";

    print(instituteUrl);

    // Retrieve admin_id from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminId = prefs.getString("admin_id");

    if (adminId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Admin ID is missing. Please log in again.")),
      );
      return;
    }

    Map<String, dynamic> instituteData = {
      "admin_id": adminId,  // Include admin ID
      "name": _instituteNameController.text,
      "description": _descriptionController.text,
      "address": _addressController.text,
      "phone_no": _phoneController.text
    };

    try {
      final response = await http.post(
        Uri.parse(instituteUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(instituteData),
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final responseData = jsonDecode(response.body);
        print(response.body);
        await prefs.setString("institute_id", responseData['data']['id'].toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Institute added successfully")),
        );
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding institute: ${errorData.toString()}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text("Get Started", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextFormField(
                  controller: _instituteNameController,
                  decoration: InputDecoration(labelText: "Name of the Institute *"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Institute name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Admin Email *"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password *"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: "Address"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Address is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Phone No"),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    }
                    if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                      return "Enter a valid 10-digit phone number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: _isLoading ? null : registerAdmin,
                  child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text("Register"),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}