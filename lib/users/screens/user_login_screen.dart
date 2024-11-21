import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/purple_flow.mp4') // Local video file in your assets
      ..setLooping(true) // Loop the video
      ..setVolume(0.0); // Set the volume to 0 if you don't want sound

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.play(); // Play the video once it's initialized
    }).catchError((error) {
      // Handle any errors that might occur during video initialization
      print("Error initializing video: $error");
      // Optionally, show an error message to the user
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Login'),
      ),
      body: Stack(
        children: [
          // Video Background
          FutureBuilder<void>(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Failed to load video."));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          // Content Layer (Login form)
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email TextField
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Default white background
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                      border: Border.all(color: Colors.deepPurple, width: 2), // Purple border color
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter Your Email',
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                      ),
                      style: TextStyle(color: Colors.deepPurple),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Password TextField
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.deepPurple, width: 2),
                    ),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Enter Your Password',
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                      ),
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Log In Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF800080),
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Log in', style: TextStyle(fontSize: 18)),
                  ),
                  // Sign Up Button
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Not registered yet? Sign up',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
