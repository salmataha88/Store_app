import 'package:app2/screens/addStore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/custom_button.dart';
import '../helper/custom_textfiled.dart';
import '../helper/databaseHelper.dart';
import '../helper/show_snackBar.dart';


class loginPage extends StatefulWidget {
  loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<loginPage> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();


  Future<void> logInSqlite() async {
    setState(() {
      isLoading = true;
    });
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      Map<String, dynamic>? userData = await DatabaseHelper.instance.getUserByEmail(email);

      if (userData != null) {
        if (userData['password'] == password) {
          print('Sign in successful for user ${userData['name']}');

          /* Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(userEmail: email)),
          ); */

          emailController.clear();
          passwordController.clear();
        }
        else {
          showSnackBar(context, 'Incorrect password');
        }
        if (email == 'salma@gmail.com') {
          // Navigate to the add store screen if the user is authorized
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStoreScreen()),
          ); 
        }
        
      } else {
        showSnackBar(context, 'User not found');
      }
    } catch (e) {
      showSnackBar(context, 'There was an error');
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
                    logInSqlite();
                  }
                },
                text: 'Login',
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'SignupPage');
                },
                child: const Text('Don\'t have an account? Signup', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}