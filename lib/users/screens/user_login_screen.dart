import 'package:flutter/material.dart';
import 'package:skillmentor/users/screens/user_home.dart';
import 'package:skillmentor/users/screens/user_registration_screen.dart';
import 'package:skillmentor/users/screens/forgot_password_screen.dart'; //

import 'admin.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  late String email, password;
  String? emailError, passwordError;
  bool showPassword = false; // Variable to toggle password visibility

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

    // Email validation
    RegExp emailExp = RegExp(
        r"^[a-zAZ0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    bool isValid = true;

    // Validate email
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'Email is invalid';
      });
      isValid = false;
    }

    // Validate password
    if (password.isEmpty || password.length < 8) {
      setState(() {
        passwordError = 'Password must be at least 8 characters';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      // Handle the login logic (e.g., send the credentials to the backend)
      print('Email: $email, Password: $password');
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserHome()));
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
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              SizedBox(height: screenHeight * .12),

              // Email TextField
              InputField(
                labelText: 'Email',
                errorText: emailError,
                onChanged: (value) {
                  setState(() {
                    email = value;
                    if (emailError != null) emailError = null;  // Clear error when user types
                  });
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autoFocus: true,
              ),
              SizedBox(height: screenHeight * .025),

              // Password TextField with Show Password functionality
              InputField(
                labelText: 'Password',
                errorText: passwordError,
                obscureText: !showPassword, // Show or hide password based on `showPassword`
                onChanged: (value) {
                  setState(() {
                    password = value;
                    if (passwordError != null) passwordError = null;  // Clear error when user types
                  });
                },
                onSubmitted: (val) => submit(),
                textInputAction: TextInputAction.done,
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword; // Toggle password visibility
                    });
                  },
                ),
              ),
              SizedBox(height: screenHeight * .03),

              // Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to ForgotPasswordScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),

              // Login Button
              FormButton(
                text: 'Log In',
                onPressed: submit,
              ),
              SizedBox(height: screenHeight * .15), // SizedBox for space

              // Sign Up Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminApp()),
                  ); // Navigate to registration screen
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Not a user, ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 6, 148),
                          fontWeight: FontWeight.bold,
                        ),
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

// Updated InputField widget to support suffixIcon for Show/Hide Password
class InputField extends StatelessWidget {
  final String? labelText;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  final Widget? suffixIcon; // Add suffixIcon to support Show/Hide password

  const InputField({
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.autoFocus = false,
    this.obscureText = false,
    this.suffixIcon, // Accept suffixIcon as parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: suffixIcon, // Set suffixIcon here
      ),
    );
  }
}

// Form Button Widget
class FormButton extends StatelessWidget {
  final String text;
  final Function? onPressed;

  const FormButton({this.text = '', this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 6, 148), // Button background color
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white, // Set text color to white
        ),
      ),
    );
  }
}
