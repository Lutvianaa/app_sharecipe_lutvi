import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserManager extends ChangeNotifier {
  String? authToken;
  final storage = FlutterSecureStorage();

  void setAuthToken(String? token) {
    authToken = token;
    notifyListeners();
  }

  Future<void> logout() async {
    // Hapus token dari penyimpanan aman
    await storage.delete(key: 'auth_token');
    authToken = null;
    notifyListeners();
  }

  bool get isAuthenticated => authToken != null;
}
