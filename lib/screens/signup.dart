import 'package:app2/helper/show_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../database/user.dart';
import '../helper/custom_button.dart';
import '../helper/custom_textfiled.dart';
import '../helper/databaseHelper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _signup() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Request location permissions
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle case where user denies location permissions
      throw Exception('User denied permissions to access the device\'s location');
    }

    // Validate input fields
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      // Show error message if any field is empty
      showSnackBar(context, 'Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      // Show error message if passwords do not match
      showSnackBar(context, 'Passwords do not match');
      return;
    }
      // Get user's current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    String location = '${position.latitude}, ${position.longitude}';
    // Create a User object
    User user = User(
      email: email,
      password: password,
      latitude: double.parse(location.split(',')[0]), // Extract latitude from location string
      longitude: double.parse(location.split(',')[1]), // Extract longitude from location string
    );

    // Add the user to the database
    try {
      await DatabaseHelper.instance.insertUser(user);
      // Show success message
      showSnackBar(context, 'User added successfully');
    } catch (e) {
      // Show error message if adding user to database fails
      showSnackBar(context, 'Failed to add user to database' );
      print('Failed to add user to database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      body: Center( // Center the column vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Signup',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center the text horizontally
              ),
              const SizedBox(height: 100),
            CustomTextfiled(
                obscureText: false,
                controller: _emailController,
                text: 'Email',
            ),
            const SizedBox(height: 15),
            CustomTextfiled(
                obscureText: true,
                controller: _passwordController,
                text: 'Password',
            ),
            const SizedBox(height: 15),
            CustomTextfiled(
                obscureText: true,
                controller: _confirmPasswordController,
                text: 'Confirm Password',
            ),
            const SizedBox(height: 15),  
          CustomButton(
            onTap: () {
              _signup();
            },
            text: 'Signup',
            ),
              const SizedBox(height: 5),
            TextButton(
              onPressed: () {
               Navigator.pushNamed(context, 'loginPage');
              },
              child: const Text('Already have an account? login', style: TextStyle(color: Colors.white),),
              ),
          ],
        ),
      ),
    ),
    );
  }
}
