import 'package:flutter/material.dart';
import 'package:flutter_database_sqflite_riverpod/HomeScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowMaterialGrid: false,
        home: HomeScreen(),
      ),
    );
  }
}