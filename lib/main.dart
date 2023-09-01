import 'package:catvsdog/Cat&DogRecog.dart';
import 'package:catvsdog/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat vs Dog',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
