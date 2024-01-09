import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiManager {
  final String baseUrl;
  final storage = FlutterSecureStorage();

  ApiManager({required this.baseUrl});

  //membuat fungsi memanggil api login.php
  Future<dynamic?> authenticate(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];
      final role = jsonResponse['role'];

      // Save the token securely
      await storage.write(key: 'auth_token', value: token);

      return {
        'token': token,
        'role': role,
      };
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  //membuat fungsi memanggil api register.php
  // ApiManager - update the register method to handle specific error messages
  Future<Map<String, dynamic>> register(String name, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse; // Return the parsed JSON response
    } else {
      throw Exception('Failed to register');
    }
  }


}
