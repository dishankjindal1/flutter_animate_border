import 'package:flutter/material.dart';
import 'package:flutter_animate_border/flutter_animate_border.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterAnimateBorderController controller1 =
      FlutterAnimateBorderController();
  final FlutterAnimateBorderController controller2 =
      FlutterAnimateBorderController();
  final FlutterAnimateBorderController controller3 =
      FlutterAnimateBorderController();
  final FlutterAnimateBorderController controller4 =
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
                FlutterAnimateBorder(
                  controller: controller1
                    ..setBoxdecoration(BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.teal.withAlpha(100)),
                    ))
                    ..setPadding(
                        EdgeInsets.symmetric(horizontal: 24, vertical: 4))
                    ..setColors([Colors.teal, Colors.transparent])
                    ..setColorsStops([0.1, 0.5]),
                  child: Text(
                    'Button',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                SizedBox.square(dimension: 24),
                FlutterAnimateBorder(
                  controller: controller2
                    ..setBoxdecoration(BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.teal.withAlpha(100)),
                    ))
                    ..setPadding(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    )
                    ..setColors([Colors.red, Colors.green, Colors.blue])
                    ..setColorsStops(
                      [0, 0.5, 1],
                    ),
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
                  controller: controller3
                    ..setBoxdecoration(BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                      border: Border.all(color: Colors.teal.withAlpha(100)),
                    ))
                    ..setLineExtent(20),
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
                GestureDetector(
                  onTap: () {
                    controller4.setLoading(!controller4.isLoading);
                  },
                  child: FlutterAnimateBorder(
                    controller: controller4
                      ..setBoxdecoration(BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.teal.withAlpha(100),
                          width: 2,
                        ),
                      )),
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
