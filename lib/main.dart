import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app2/helper/storeProvider.dart'; 
import 'package:app2/screens/login.dart';
import 'package:app2/screens/signup.dart';
import 'package:app2/helper/databaseHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()), 
      ],
      child: MaterialApp(
        routes: {
          'loginPage': (context) => loginPage(),
          'SignupPage': (context) => SignupPage(),
        },
        initialRoute: 'loginPage',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
