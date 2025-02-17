import 'package:flutter/material.dart';
import 'package:flutter_animate_border/flutter_animate_border.dart';

import 'package:gap/gap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterAnimateBorderController controller =
      FlutterAnimateBorderController();

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
                GestureDetector(
                  onTap: () {
                    controller.setRunning(!controller.isRunning);
                  },
                  child: FlutterAnimateBorder(
                    controller: controller
                      ..setGradient(
                        RadialGradient(
                          radius: 1,
                          colors: [
                            Colors.teal,
                            Colors.transparent,
                          ],
                        ),
                      )
                      ..setLineThickness(2)
                      ..setLineWidth(48)
                      ..setLinePadding(0)
                      ..setCornerRadius(40),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        'Container 1',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Gap(24),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController()
                    ..setGradient(
                      RadialGradient(
                        radius: 1,
                        colors: [
                          Colors.teal,
                          Colors.transparent,
                        ],
                      ),
                    )
                    ..setLineThickness(2)
                    ..setLineWidth(48)
                    ..setLinePadding(0)
                    ..setCornerRadius(40),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          40,
                        ),
                        border: Border.all(
                            width: 2, color: Colors.teal.withAlpha(50))),
                    child: Text(
                      'Container 2',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController()
                    ..setGradient(
                      RadialGradient(
                        radius: 1,
                        colors: [
                          Colors.teal,
                          Colors.transparent,
                        ],
                      ),
                    )
                    ..setLineThickness(2)
                    ..setLineWidth(48)
                    ..setLinePadding(0)
                    ..setCornerRadius(40),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 24, vertical: 4)),
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                    child: Text(
                      'Button 1',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
                Gap(24),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController()
                    ..setGradient(
                      LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                        ],
                      ),
                    )
                    ..setLineThickness(1)
                    ..setLineWidth(24)
                    ..setLinePadding(-1)
                    ..setCornerRadius(40),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 24, vertical: 4)),
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(width: 1, color: Colors.black)),
                      ),
                    ),
                    child: Text(
                      'Button 2',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController()
                    ..setGradient(
                      RadialGradient(
                        radius: 1,
                        colors: [
                          Colors.teal,
                          Colors.teal,
                        ],
                      ),
                    )
                    ..setLineThickness(4)
                    ..setLineWidth(24)
                    ..setLinePadding(20)
                    ..setCornerRadius(40),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ),
                Gap(24),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController()
                    ..setGradient(
                      LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                        ],
                      ),
                    )
                    ..setLineThickness(4)
                    ..setLineWidth(30)
                    ..setLinePadding(-20)
                    ..setCornerRadius(40),
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController()
                    ..setGradient(
                      LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                        ],
                      ),
                    )
                    ..setLineThickness(4)
                    ..setLineWidth(30)
                    ..setLinePadding(-20),
                  child: Image.network('https://picsum.photos/150'),
                ),
                Gap(24),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController()
                    ..setGradient(
                      LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                        ],
                      ),
                    )
                    ..setLineThickness(4)
                    ..setLineWidth(30)
                    ..setLinePadding(0),
                  child: Image.network('https://picsum.photos/150'),
                ),
                Gap(24),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController()
                    ..setGradient(
                      LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                        ],
                      ),
                    )
                    ..setLineThickness(4)
                    ..setLineWidth(30)
                    ..setLinePadding(20),
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
