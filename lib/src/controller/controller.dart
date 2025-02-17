import 'package:flutter/material.dart';

/// [FlutterAnimateBorderController] is used to customize each part of the package.
///
/// [loopDuration] -> is while animation duration
/// [loopCurve] -> is to determine how the value on animation will change with respect to time
/// [gradient] -> is used to determine the [Gradient] of the animating border
/// [isRunning] -> is used to start/stop the animation
class FlutterAnimateBorderController extends ChangeNotifier {
  /// [FlutterAnimateBorderController] is used to initialize the controller with [loopDuration] and [loopCurve]
  /// as this are required.
  FlutterAnimateBorderController({
    this.loopDuration = const Duration(seconds: 3),
    this.loopCurve = Curves.linear,
  });

  /// determine how long will be the whole animation duration cycle
  final Duration loopDuration;

  /// determine how the value on animation will change with respect to time
  final Curve loopCurve;

  Gradient? _gradient;

  /// used to determine the gradient of the animating border
  Gradient? get gradient => _gradient;

  /// set the gradient of the animating border
  void setGradient(Gradient value) {
    _gradient = value;
    notifyListeners();
  }

  double _lineThickness = 1.0;

  /// used to determine the thickness of the animating border
  double get lineThickness => _lineThickness;

  /// set the thickness of the animating border
  void setLineThickness(double value) {
    _lineThickness = value;
    notifyListeners();
  }

  double _cornerRadius = 0;

  /// used to determine the corner radius of the animating border
  double get cornerRadius => _cornerRadius;

  /// set the corner radius of the animating border
  void setCornerRadius(double value) {
    _cornerRadius = value;
    notifyListeners();
  }

  double _lineWidth = 50.0;

  /// [lineWidth] -> is used to determine the length of the animation line range
  double get lineWidth => _lineWidth;

  /// [setLineWidth] -> is used to set the length of the animation line range
  void setLineWidth(double value) {
    _lineWidth = value;
    notifyListeners();
  }

  double _linePadding = 0;

  /// line padding offset to determine the anchor
  Offset get linePaddingOffset => Offset(-_linePadding, -_linePadding);

  /// used to determine line padding of the border. It helps position the animation inward(negative values) or outward(positive values)
  double get linePadding => _linePadding;

  /// set the line padding to determine the offset inward(negative values) or outward(positive values)
  void setLinePadding(double value) {
    _linePadding = value;
    notifyListeners();
  }

  bool _isRunning = true;

  /// Get the info of loading if [true] then it is running, and [false] it is stopped
  bool get isRunning => _isRunning;

  /// Used to set start[true] and stop[false] the border loading
  void setRunning(bool value) {
    _isRunning = value;
    notifyListeners();
  }
}
