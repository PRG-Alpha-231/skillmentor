import 'package:flutter/material.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurple,),
        body: Column(
      children: [
        
        TextField(
          decoration: InputDecoration(hintText: 'Enter Your Email'),
        ),
        TextField(
          decoration: InputDecoration(hintText: 'Enter Your Password'),
        ),
       
        ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF800080), // Valid ARGB color
              ),
              onPressed: () {
                // Add action here
              },
              child: Text('Log in'),
            ),
            Spacer(),
       TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) return Colors.red;
              return null; // Defer to the widget's default.
            }),
          ),
          onPressed: () {},
          child: Text('Not registered yet,sign up',style: TextStyle(color: Colors.purple

          ),),
        ),

        
      ],
    ));
  }
}
