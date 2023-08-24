import 'package:cancer/screens/home2.dart';
import 'package:cancer/screens/loading.dart';
import 'package:cancer/screens/login.dart';
import 'package:cancer/screens/predict.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen2(),
    );
  }
}

