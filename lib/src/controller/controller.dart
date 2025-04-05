import 'package:flutter/material.dart';

/// [FlutterAnimateBorderController] is used to customize each part of the package.
///
/// [loopDuration] -> is while animation duration
/// [loopCurve] -> is to determine how the value on animation will change with respect to time
/// [isLoading] -> is used to start/stop the animation
class FlutterAnimateBorderController {
  /// [FlutterAnimateBorderController] is used to initialize the controller with [loopDuration] and [loopCurve]
  /// as this are required.
  FlutterAnimateBorderController({
    this.isLoading = true,
    this.loopDuration = const Duration(seconds: 3),
    this.loopCurve = Curves.linear,
  });

  /// [loopDuration] -> is while animation duration
  final Duration loopDuration;

  /// [loopCurve] -> is to determine how the value on animation will change with respect to time
  final Curve loopCurve;

  /// [isLoading] -> is used to start/stop the animation
  bool isLoading;
}
