import 'package:flutter/material.dart';
import 'package:gesture_user_interface/Authentication/login.dart';
import 'package:gesture_user_interface/home.dart';
import 'package:gesture_user_interface/ipconfig.dart';
import 'package:gesture_user_interface/Authentication/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:ui' as ui;
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
//hfjdkf
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      routes: {
        //'/': (context) => Register(),
        '/': (context) => Register(),
        '/home': (context) => MyDropdownWidget(),
        '/login': (context) => LoginPage(),
        '/IP' : (context) => ipconfig(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     
    );
  }
}

