import 'package:flutter/material.dart';
import 'Views/Notes/llista_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crud amb Flutter',
      theme: ThemeData(
          primarySwatch: Colors.green),
           home: const Llista(),
    );
  }
}
