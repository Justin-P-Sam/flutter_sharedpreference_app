// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_task_app/utilits/color_constants.dart';
import 'package:flutter_task_app/view/global_widgets/custom_button.dart';
import 'package:flutter_task_app/view/home_screen/home_screen.dart';
import 'package:flutter_task_app/view/registration_screen/registration_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';


final emailController = TextEditingController();
final pwdController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    checkSavedCredentials(); // Check for saved credentials on app startup
  }

  // Check if credentials are already saved
  void checkSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    if (savedUsername != null && savedPassword != null) {
      log("Auto-login with saved credentials: $savedUsername");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  // Login Function
  void login() async {
    String username = emailController.text;
    String password = pwdController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      
  
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegistrationScreen()),
      );
    } else {
      AlertDialog(actions: [Text("Error: Please enter email and password!")],);
      log("Error: Please enter email and password!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Sign in to Your Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Your Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: pwdController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Your Password",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text("Remember me"),
                Spacer(),
                Text(
                  "Forgot Password",
                  style: TextStyle(color: ColorConstants.PRIMARY),
                )
              ],
            ),
            SizedBox(height: 40),
            CustomButton(
              buttonText: "Sign in",
              onButtonPressed: () {
                log("Login button clicked");
                login();
              },
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                GestureDetector(
                  onTap: () {
                    // Navigate to the register screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                  },
                  child: Text(
                    " Sign Up",
                    style: TextStyle(color: ColorConstants.PRIMARY),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}