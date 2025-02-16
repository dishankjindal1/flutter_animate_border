import 'package:flutter/material.dart';

/// [FlutterAnimateBorderController] is used to customize each part of the package.
///
/// [loopDuration] -> is while animation duration
/// [loopCurve] -> is to determine how the value on animation will change with respect to time
/// [boxDecoration] -> is used to determine the [Decoration] of the underline container
/// [padding] -> is used to determine the [Padding] of the container
/// [colors] -> is used to determine the colors
/// [colorsStops] -> is used to determine the proportions of the [colors] range
/// [isLoading] -> is used to start/stop the animation
class FlutterAnimateBorderController extends ChangeNotifier {
  /// [FlutterAnimateBorderController] is used to initialize the controller with [loopDuration] and [loopCurve]
  /// as this are required.
  FlutterAnimateBorderController({
    this.loopDuration = const Duration(seconds: 3),
    this.loopCurve = Curves.linear,
  });

  /// [loopDuration] -> is while animation duration
  final Duration loopDuration;

  /// [loopCurve] -> is to determine how the value on animation will change with respect to time
  final Curve loopCurve;

  BoxDecoration? _boxDecoration;

  /// [boxDecoration] -> is used to determine the [BoxDecoration] of the underline container
  BoxDecoration? get boxDecoration => _boxDecoration;

  /// [setBoxdecoration] -> is used to set the [BoxDecoration] of the underline container
  void setBoxdecoration(BoxDecoration value) {
    _boxDecoration = value;
    notifyListeners();
  }

  EdgeInsetsGeometry? _padding;

  /// [padding] -> is used to determine the [Padding] of the container
  EdgeInsetsGeometry? get padding => _padding;

  /// [setPadding] -> is used to set the [Padding] of the container
  void setPadding(EdgeInsetsGeometry value) {
    _padding = value;
    notifyListeners();
  }

  List<Color>? _colors = [Colors.teal, Colors.teal];

  /// [colors] -> is used to determine the colors
  List<Color>? get colors => _colors;

  /// [colors] -> is used to set the colors
  void setColors(List<Color> value) {
    _colors = value;
    notifyListeners();
  }

  List<double>? _colorsStops = [0, 1];

  /// [colorsStops] -> is used to determine the proportions of the [colors] range
  List<double>? get colorsStops => _colorsStops;

  /// [setColorsStops] -> is used to set the proportions of the [colors] range
  void setColorsStops(List<double> value) {
    _colorsStops = value;
    notifyListeners();
  }

  double _lineExtent = 50.0;

  /// [lineExtent] -> is used to determine the length of the animation line range
  double get lineExtent => _lineExtent;

  /// [setLineExtent] -> is used to set the length of the animation line range
  void setLineExtent(double value) {
    _lineExtent = value;
    notifyListeners();
  }

  bool _isLoading = true;

  /// Get the info of loading if [true] then it is running, and [false] it is stopped
  bool get isLoading => _isLoading;

  /// Used to set start[true] and stop[false] the border loading
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
