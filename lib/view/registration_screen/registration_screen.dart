// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_task_app/utilits/color_constants.dart';
import 'package:flutter_task_app/view/global_widgets/custom_button.dart';
import 'package:flutter_task_app/view/home_screen/home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegistrationScreen> {
  final TextEditingController passwordCntrl = TextEditingController();
  final TextEditingController pwdConfirmCntrl = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String username = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    loadCredentials(); // Load saved credentials on screen load
  }

  // Retrieve credentials from SharedPreferences
  void loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'No username found';
      password = prefs.getString('password') ?? 'No password found';
      emailController.text = username; // Pre-fill the email field
    });

    log("Loaded credentials: Username: $username, Password: $password");
  }

  // Save new credentials
  void register() async {
    String email = emailController.text.trim();
    String password = passwordCntrl.text.trim();
    String confirmPassword = pwdConfirmCntrl.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', email);
    await prefs.setString('password', password);

    log("Credentials saved: Username: $email, Password: $password");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Create Your Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Your Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: passwordCntrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Your Password",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: pwdConfirmCntrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            SizedBox(height: 40),
            CustomButton(
              buttonText: "Register",
              onButtonPressed: register, // Call the register method
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back to login screen
                  },
                  child: Text(
                    " Sign In",
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