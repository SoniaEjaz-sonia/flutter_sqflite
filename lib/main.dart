import 'package:flutter/material.dart';
import 'package:flutter_sqflite/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
