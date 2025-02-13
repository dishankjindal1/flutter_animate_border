import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate_border/src/painters/animate_border_painter.dart';

class FlutterAnimateBorder extends StatefulWidget {
  const FlutterAnimateBorder({
    required this.child,
    required this.decoratedBox,
    this.padding = const EdgeInsets.all(0.0),
    this.loopDuration = const Duration(seconds: 3),
    this.loopCurve = Curves.linear,
    this.colors = const [Colors.teal, Colors.teal],
    this.colorsStops = const [0, 1],
    super.key,
  });

  final Widget child;
  final BoxDecoration decoratedBox;
  final EdgeInsets padding;
  final Duration loopDuration;
  final Curve loopCurve;
  final List<Color> colors;
  final List<double> colorsStops;

  @override
  State<FlutterAnimateBorder> createState() => _FlutterAnimateBorderState();
}

class _FlutterAnimateBorderState extends State<FlutterAnimateBorder>
    with SingleTickerProviderStateMixin {
  /// Mutable
  Offset actor = Offset(0, 0);
  Offset box = Offset(0, 0);
  double radius = 0;
  double thickness = 0;
  Gradient? gradient;

  /// Immutable
  final globalKey = GlobalKey();

  /// Controllers
  late final AnimationController animationController;
  late final Animation<double> animationValue;

  void _calculate() {
    final renderBox =
        globalKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      if (mounted) {
        setState(() {
          box = Offset(renderBox.size.width, renderBox.size.height);
          gradient = widget.decoratedBox.gradient;
          thickness = widget.decoratedBox.border?.bottom.width ?? thickness;
          radius =
              (widget.decoratedBox.borderRadius as BorderRadius?)
                  ?.bottomLeft
                  .x ??
              0;
          final findTheMinSize = math.min(box.dx, box.dy);
          final maxCornerRadius = findTheMinSize / 2;
          final pickMinCornerRadius = math.min(radius, maxCornerRadius);
          radius = pickMinCornerRadius;
        });
      }
    } else {
      scheduleMicrotask(_calculate);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.loopDuration,
    );

    animationValue = animationController.drive(
      CurveTween(curve: widget.loopCurve),
    );

    animationController.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculate();
      animationController.addListener(_updateUi);
    });
  }

  // Helper function to calculate arc points
  Offset arcPoint(double cx, double cy, double startAngle, double angle) {
    final x = cx + radius * math.cos(startAngle + angle);

    final y = cy + radius * math.sin(startAngle + angle);

    return Offset(x, y);
  }

  void _updateUi() {
    if (mounted) {
      setState(() {
        final edgeH = box.dx - 2 * radius;
        final edgeV = box.dy - 2 * radius;
        final arc = (math.pi / 2) * radius;
        final perimeter = 2 * (edgeH + edgeV) + 4 * arc;

        double d = perimeter * animationValue.value;

        if (d < edgeH) {
          actor = Offset(d + radius, 0);
          return;
        }

        d -= edgeH;

        if (d < arc) {
          final angle = d / radius;
          actor = arcPoint(box.dx - radius, radius, 3 * math.pi / 2, angle);
          return;
        }

        d -= arc;

        if (d < edgeV) {
          actor = Offset(box.dx, d + radius);
          return;
        }

        d -= edgeV;

        if (d < arc) {
          final angle = d / radius;
          actor = arcPoint(box.dx - radius, box.dy - radius, 0, angle);
          return;
        }

        d -= arc;

        if (d < edgeH) {
          actor = Offset(box.dx - d - radius, box.dy);
          return;
        }

        d -= edgeH;

        if (d < arc) {
          final angle = d / radius;
          actor = arcPoint(radius, box.dy - radius, math.pi / 2, angle);
          return;
        }

        d -= arc;

        if (d < edgeV) {
          actor = Offset(0, box.dy - d - radius);
          return;
        }

        d -= edgeV;

        if (d < arc) {
          final angle = d / radius;
          actor = arcPoint(radius, radius, math.pi, angle);
          return;
        }

        d -= arc;
      });
    }
  }

  @override
  void didUpdateWidget(covariant FlutterAnimateBorder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.decoratedBox != widget.decoratedBox) {
      _calculate();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _calculate();
  }

  @override
  void dispose() {
    animationController.removeListener(_updateUi);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    /// Because image widget can infer its own height and width
    /// after loading, so we need to count in that new dimensions
    if (widget.child is Image) {
      final renderBox =
          globalKey.currentContext?.findRenderObject() as RenderBox?;

      box = Offset(
        renderBox?.size.width ?? box.dx,
        renderBox?.size.height ?? box.dy,
      );
    }

    return CustomPaint(
      willChange: kDebugMode,
      foregroundPainter: AnimateBorderPainter(
        actors: [actor],
        strokeWidth: thickness,
        radius: radius,
        gradient: LinearGradient(
          colors: widget.colors,
          stops: widget.colorsStops,
          tileMode: TileMode.mirror,
        ),
      ),
      child: Container(
        key: globalKey,
        padding: widget.padding,
        alignment: Alignment.center,
        decoration: widget.decoratedBox,
        child: widget.child,
      ),
    );
  }
}
