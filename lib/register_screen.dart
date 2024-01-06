import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import your login screen
import 'package:provider/provider.dart';
import 'api_manager.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);

    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    try {
      await apiManager.register(name, email, password);
      // Show a toast on successful registration

      Navigator.pushReplacementNamed(context, '/');
      // Handle successful registration
    } catch (e) {
      print('Registration failed. Error: $e');
      // Handle registration failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ShaRecipe.png', // Replace with your logo asset path
              width: 100,
              height: 100,
              // Adjust width and height as needed
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person), // Icon for name
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email), // Icon for email/phone number
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock), // Icon for password
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Already have an Account? Login Here',
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
