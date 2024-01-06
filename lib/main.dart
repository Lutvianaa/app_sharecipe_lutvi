import 'package:crud_php/login_screen.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'homescreen.dart';
// import 'register_screen.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';
import 'user_manager.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  final ApiManager apiManager = ApiManager(baseUrl: 'http://192.168.43.198/api_php');

  //provider digunakan untuk mengirimkan data dari main.dart ke sub page, sehingga semua yang berada pada context provider bisa memanggil datanya.
  //Pada case ini data baseUrl disebar ke page lain
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserManager()),
        Provider.value(value: apiManager),
      ],
      child: MaterialApp(
        title: 'ShaRecipe',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}