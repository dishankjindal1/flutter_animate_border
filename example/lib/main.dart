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
        color: Color(0xFF0F0F1F),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterAnimateBorder(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  decoratedBox: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.teal.withAlpha(100)),
                  ),
                  colors: [Colors.teal, Colors.transparent],
                  colorsStops: [0.1, 0.5],
                  child: Text(
                    'Button',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                SizedBox.square(dimension: 24),
                FlutterAnimateBorder(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  decoratedBox: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.teal.withAlpha(100)),
                  ),
                  colors: [Colors.red, Colors.green, Colors.blue],
                  colorsStops: [0, 0.5, 1],
                  child: Text(
                    'Button',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox.square(dimension: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterAnimateBorder(
                  decoratedBox: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.teal.withAlpha(100)),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox.square(dimension: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterAnimateBorder(
                  decoratedBox: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.teal.withAlpha(100),
                      width: 2,
                    ),
                  ),
                  child: Image.network('https://picsum.photos/150'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
