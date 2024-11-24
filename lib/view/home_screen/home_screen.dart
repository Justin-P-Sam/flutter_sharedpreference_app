
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_task_app/utilits/color_constants.dart';
import 'package:flutter_task_app/view/login_screen/login_screen.dart';


import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<HomeScreen> {
    int selectindex=0;

  @override
  Widget build(BuildContext context) {
    
     return Scaffold(
      
     appBar: AppBar(title: Text("home screen"),),
     body:  Column(
       children: [
       // Text("$saved")
        ElevatedButton(
          style:  ElevatedButton.styleFrom(
            backgroundColor:ColorConstants.PRIMARY
                      ),
                  onPressed: () async { 
                    SharedPreferences prefs=await SharedPreferences.getInstance();
                    await prefs.remove('username');
                    await prefs.remove('password');
                   Navigator.pushReplacement( 
                      context,
                      MaterialPageRoute(
                        builder:  (context) => LoginScreen(),)
                       );
                },
                 child: Text("Logout")),
       ],
     ),
    );
  }
}