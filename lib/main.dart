import 'package:app2/helper/databaseHelper.dart';
import 'package:app2/screens/login.dart';
import 'package:app2/screens/signup.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Initialize SQLite database
  await DatabaseHelper.instance.database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'loginPage': (context) => loginPage(),
        'SignupPage': (context) => SignupPage(),
        
      },
      initialRoute: 'loginPage',
      debugShowCheckedModeBanner: false,
    );
  }
}




