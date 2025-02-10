import 'package:flutter/material.dart';
import 'package:flutter_animate_border/flutter_animate_border.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Material(
        child: SizedBox(
          width: 200,
          height: 50,
          child: FlutterAnimateBorder(),
        ),
      ),
    );
  }
}
