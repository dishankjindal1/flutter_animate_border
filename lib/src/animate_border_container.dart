import 'package:flutter/widgets.dart';

class FlutterAnimateBorder extends StatefulWidget {
  const FlutterAnimateBorder(this.label, {super.key});

  final Widget label;

  @override
  State<FlutterAnimateBorder> createState() => _FlutterAnimateBorderState();
}

class _FlutterAnimateBorderState extends State<FlutterAnimateBorder> {
  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return const Placeholder();
    });
  }
}
