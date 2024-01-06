import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import your register screen file

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay for 3 seconds and then navigate to Login Screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your LoginScreen
      );
    });
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4C4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo goes here
            Image.asset(
              'assets/ShaRecipe.png', // Replace with your logo asset path
              width: 100,
              height: 100,
              // Adjust width and height as needed
            ),
            SizedBox(height: 20), // Adding space between logo and text
          ],
        ),
      ),
    );
  }
}
