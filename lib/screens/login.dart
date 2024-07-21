import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../helper/custom_button.dart';
import '../helper/custom_textfiled.dart';
import '../helper/databaseHelper.dart';
import '../helper/show_snackBar.dart';
import '../helper/storeProvider.dart';
import 'homePage.dart';
import 'addStore.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

Future<void> logInSqlite(BuildContext context) async {
  setState(() {
    isLoading = true;
  });

  try {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final userData = await DatabaseHelper.instance.getUserByEmail(email, storeProvider);

    if (userData != null) {
      if (userData['password'] == password) {
        print('Sign in successful for user ${userData['email']}');

        // Navigate to the appropriate screen based on the user's email
        if (email == 'salma@gmail.com') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStoreScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }

        emailController.clear();
        passwordController.clear();
      } else {
        showSnackBar(context, 'Incorrect password');
      }
    } else {
      showSnackBar(context, 'User not found');
    }
  } catch (e) {
    showSnackBar(context, 'Failed to log in. Please try again later.');
    print('error:$e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 150),
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              CustomTextfiled(
                obscureText: false,
                controller: emailController,
                text: 'Email',
              ),
              const SizedBox(height: 15),
              CustomTextfiled(
                obscureText: true,
                controller: passwordController,
                text: 'Password',
              ),
              const SizedBox(height: 15),
              CustomButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    logInSqlite(context);
                  }
                },
                text: 'Login',
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'SignupPage');
                },
                child: const Text('Don\'t have an account? Signup', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
