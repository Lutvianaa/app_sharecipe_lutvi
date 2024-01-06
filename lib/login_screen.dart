import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';
import 'user_manager.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _authenticate(BuildContext context) async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);
    final userManager = Provider.of<UserManager>(context, listen: false);

    final username = emailController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Tampilkan pesan kesalahan jika email atau password kosong
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter both email and password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return; // Hentikan proses autentikasi jika email atau password kosong
    }

    try {
      final token = await apiManager.authenticate(username, password);
      if (token != null) {
        userManager.setAuthToken(token);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Tampilkan pesan kesalahan jika autentikasi gagal (misalnya, email atau password tidak sesuai)
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Invalid email or password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Authentication failed. Error: $e');
      // Handle other authentication failures if necessary
    }
  }
  // Fungsi untuk logout saat login screen ditampilkan
  void _checkAndLogout(BuildContext context) async {
    final userManager = Provider.of<UserManager>(context, listen: false);
    final isAuthenticated = userManager.isAuthenticated;

    if (isAuthenticated) {
      await userManager.logout();
    }
  }


  @override
  Widget build(BuildContext context) {
    _checkAndLogout(context);
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email), // Icon for email
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
              onPressed: () => _authenticate(context),
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'Don\'t have an account? Register',
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
    );
  }
}
