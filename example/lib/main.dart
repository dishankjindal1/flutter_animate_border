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
      FlutterAnimateBorderController(isLoading: true);
  final FlutterAnimateBorderController controller2 =
      FlutterAnimateBorderController(isLoading: true);

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
                    setState(() {
                      controller.doFreeze = !controller.doFreeze;
                    });
                  },
                  child: FlutterAnimateBorder(
                    controller: controller,
                    lineThickness: 2,
                    lineWidth: 48,
                    linePadding: 0,
                    cornerRadius: 40,
                    gradient: RadialGradient(
                      radius: 1,
                      colors: [
                        Colors.teal,
                        Colors.transparent,
                      ],
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        'Container 1',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Gap(18),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController(),
                  lineThickness: 2,
                  lineWidth: 48,
                  linePadding: 0,
                  cornerRadius: 40,
                  gradient: RadialGradient(
                    radius: 1,
                    colors: [
                      Colors.teal,
                      Colors.transparent,
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          40,
                        ),
                        border: Border.all(
                            width: 2, color: Colors.teal.withAlpha(50))),
                    child: Text(
                      'Container 2',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Gap(18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController(),
                  lineThickness: 2,
                  lineWidth: 48,
                  linePadding: 0,
                  cornerRadius: 40,
                  gradient: RadialGradient(
                    radius: 1,
                    colors: [
                      Colors.teal,
                      Colors.transparent,
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 18, vertical: 4)),
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                    child: Text(
                      'Button 1',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                Gap(18),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController(),
                  lineThickness: 1,
                  lineWidth: 18,
                  linePadding: -1,
                  cornerRadius: 40,
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 18, vertical: 4)),
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(width: 1, color: Colors.black)),
                      ),
                    ),
                    child: Text(
                      'Button 2',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Gap(18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController(),
                  lineThickness: 4,
                  lineWidth: 18,
                  linePadding: 20,
                  cornerRadius: 40,
                  gradient: RadialGradient(
                    radius: 1,
                    colors: [
                      Colors.teal,
                      Colors.teal,
                    ],
                  ),
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
                Gap(18),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController(),
                  lineThickness: 4,
                  lineWidth: 30,
                  linePadding: -20,
                  cornerRadius: 40,
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.all(18),
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
            Gap(18),
            Wrap(
              spacing: 18,
              runSpacing: 18,
              alignment: WrapAlignment.center,
              children: [
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController(),
                  lineThickness: 4,
                  lineWidth: 30,
                  linePadding: -20,
                  cornerRadius: 0,
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                    ],
                  ),
                  child: Image.network('https://picsum.photos/150'),
                ),
                FlutterAnimateBorder(
                  controller: FlutterAnimateBorderController(),
                  lineThickness: 4,
                  lineWidth: 120,
                  linePadding: 0,
                  cornerRadius: 16,
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                    ],
                  ),
                  child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network('https://picsum.photos/150')),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      controller2.doFreeze = !controller2.doFreeze;
                    });
                  },
                  child: FlutterAnimateBorder(
                    controller: controller2,
                    lineThickness: 4,
                    lineWidth: 30,
                    linePadding: 20,
                    cornerRadius: 0,
                    gradient: LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.green,
                        Colors.blue,
                      ],
                    ),
                    child: Image.network('https://picsum.photos/150'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
