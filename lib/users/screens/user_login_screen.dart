import 'package:flutter/material.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  late String email, password;
  String? emailError, passwordError;

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

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      // Handle the login logic (e.g., send the credentials to the backend)
      print('Email: $email, Password: $password');
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
                  });
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autoFocus: true,
              ),
              SizedBox(height: screenHeight * .025),

              // Password TextField
              InputField(
                labelText: 'Password',
                errorText: passwordError,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                onSubmitted: (val) => submit(),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: screenHeight * .03),

              // Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),

              // Login Button
              FormButton(
                text: 'Log In',
                onPressed: submit,
              ),
              SizedBox(height: screenHeight * .15),

              // Sign Up Link
              TextButton(
                onPressed: () {
                  // Navigate to register screen
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
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

// Input Field Widget
class InputField extends StatelessWidget {
  final String? labelText;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;

  const InputField({
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.autoFocus = false,
    this.obscureText = false,
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
