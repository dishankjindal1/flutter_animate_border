import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate_border/src/controller/controller.dart';
import 'package:flutter_animate_border/src/painters/default_painter.dart';

/// [FlutterAnimateBorder] is the main widget which wrap around your content. Control your animation via [FlutterAnimateBorderController]
class FlutterAnimateBorder extends StatefulWidget {
  /// constructor
  const FlutterAnimateBorder({
    required this.controller,
    required this.child,
    this.color = Colors.black,
    this.cornerRadius = 4,
    this.lineThickness = 4.0,
    this.lineWidth = 50.0,
    this.linePadding = 0,
    this.gradient,
    super.key,
  });

  /// This controller is used to control the behavior and look of the
  /// widget.
  final FlutterAnimateBorderController controller;

  /// [color] -> is used to determine the default [Gradient] of the animating border
  final Color color;

  /// used to determine the corner radius of the animating border
  final double cornerRadius;

  /// used to determine the thickness of the animating border
  final double lineThickness;

  /// [lineWidth] -> is used to determine the length of the animation line range
  final double lineWidth;

  /// [linePadding] -> line padding offset to determine the anchor
  final double linePadding;

  /// [gradient] -> is used to determine the [Gradient] of the animating border
  final Gradient? gradient;

  /// Pass your [Text] widget or [Image] widget to it
  final Widget child;

  @override
  State<FlutterAnimateBorder> createState() => _FlutterAnimateBorderState();

  /// [linePaddingOffset] -> line padding offset to determine the anchor
  Offset get linePaddingOffset => Offset(-linePadding, -linePadding);
}

class _FlutterAnimateBorderState extends State<FlutterAnimateBorder>
    with SingleTickerProviderStateMixin {
  /// Mutable
  Offset actor = Offset(0, 0);
  Offset box = Offset(0, 0);
  double radius = 0;
  bool isReady = false;

  /// important to store the global key of the widget
  /// this is most import for the widget which can change shape dynamically
  /// like [Image] widget
  final globalKey = GlobalKey();

  /// Controllers
  late final AnimationController animationController;
  late final Animation<double> animationValue;

  void _calculate() {
    scheduleMicrotask(() {
      if (mounted && globalKey.currentContext != null) {
        final renderBox =
            globalKey.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          box = Offset(renderBox.size.width, renderBox.size.height);
          radius = widget.cornerRadius;
          final findTheMinSize = math.min(box.dx, box.dy);
          final maxCornerRadius = findTheMinSize / 2;
          final pickMinCornerRadius = math.min(radius, maxCornerRadius);
          radius = pickMinCornerRadius;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.controller.loopDuration,
    );

    animationValue = animationController.drive(
      CurveTween(curve: widget.controller.loopCurve),
    );

    animationController.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculate();
      animationController.addListener(_updateUi);
    });
  }

  // Helper function to calculate arc points
  Offset arcPoint(
    double cx,
    double cy,
    double startAngle,
    double angle,
    double radius,
  ) {
    final x = cx + radius * math.cos(startAngle + angle);

    final y = cy + radius * math.sin(startAngle + angle);

    return Offset(x, y);
  }

  void _updateUi() {
    if (mounted) {
      setState(() {
        if (widget.controller.doFreeze) {
          animationController.stop();
          return;
        }

        final adjustedWidth =
            (box.dx + 2 * widget.linePadding)
                .clamp(0, double.infinity)
                .toDouble();
        final adjustedHeight =
            (box.dy + 2 * widget.linePadding)
                .clamp(0, double.infinity)
                .toDouble();
        final adjustedRadius =
            radius > adjustedWidth / 2 || radius > adjustedHeight / 2
                ? math.min(adjustedWidth / 2, adjustedHeight / 2)
                : radius;

        final edgeH = (adjustedWidth - 2 * adjustedRadius);
        final edgeV = (adjustedHeight - 2 * adjustedRadius);
        final arc = ((math.pi / 2) * adjustedRadius);
        final perimeter = 2 * (edgeH + edgeV) + 4 * arc;

        double d = perimeter * animationValue.value;

        // Offset actor position by padding
        final paddingOffset = widget.linePaddingOffset;

        if (d < edgeH) {
          actor = Offset(d + adjustedRadius, 0) + paddingOffset;
          return;
        }

        d -= edgeH;

        if (d < arc) {
          final angle = d / adjustedRadius;
          actor =
              arcPoint(
                adjustedWidth - adjustedRadius,
                adjustedRadius,
                3 * math.pi / 2,
                angle,
                adjustedRadius,
              ) +
              paddingOffset;
          return;
        }

        d -= arc;

        if (d < edgeV) {
          actor = Offset(adjustedWidth, d + adjustedRadius) + paddingOffset;
          return;
        }

        d -= edgeV;

        if (d < arc) {
          final angle = d / adjustedRadius;
          actor =
              arcPoint(
                adjustedWidth - adjustedRadius,
                adjustedHeight - adjustedRadius,
                0,
                angle,
                adjustedRadius,
              ) +
              paddingOffset;
          return;
        }

        d -= arc;

        if (d < edgeH) {
          actor =
              Offset(adjustedWidth - d - adjustedRadius, adjustedHeight) +
              paddingOffset;
          return;
        }

        d -= edgeH;

        if (d < arc) {
          final angle = d / adjustedRadius;
          actor =
              arcPoint(
                adjustedRadius,
                adjustedHeight - adjustedRadius,
                math.pi / 2,
                angle,
                adjustedRadius,
              ) +
              paddingOffset;
          return;
        }

        d -= arc;

        if (d < edgeV) {
          actor =
              Offset(0, adjustedHeight - d - adjustedRadius) + paddingOffset;
          return;
        }

        d -= edgeV;

        if (d < arc) {
          final angle = d / adjustedRadius;
          actor =
              arcPoint(
                adjustedRadius,
                adjustedRadius,
                math.pi,
                angle,
                adjustedRadius,
              ) +
              paddingOffset;
          return;
        }

        d -= arc;
      });
    }
  }

  @override
  void didUpdateWidget(covariant FlutterAnimateBorder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.hashCode != widget.hashCode) {
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
    if (globalKey.currentWidget != null) {
      isReady = true;

      /// Because image widget can infer its own height and width
      /// after loading, so we need to count in that new dimensions
      final renderBox =
          globalKey.currentContext?.findRenderObject() as RenderBox?;

      box =
          Offset(
            renderBox?.size.width ?? box.dx,
            renderBox?.size.height ?? box.dy,
          ) +
          widget.linePaddingOffset +
          widget.linePaddingOffset;
      _calculate();

      if (widget.controller.doFreeze) {
        if (animationController.isAnimating) {
          animationController.stop();
        }
      } else {
        if (!animationController.isAnimating) {
          animationController.repeat();
        }
      }
    }

    final defaultGradient = LinearGradient(
      colors: [widget.color, widget.color],
    );

    if (!isReady) {
      return SizedBox(key: globalKey, child: widget.child);
    }
    return CustomPaint(
      key: globalKey,
      foregroundPainter: DefaultPainter(
        widget.controller.isLoading,
        actors: [actor],
        cornerRadius: radius,
        lineThickness: widget.lineThickness,
        lineWidth: widget.lineWidth,
        linePadding: widget.linePadding,
        gradient: widget.gradient ?? defaultGradient,
      ),
      child: widget.child,
    );
  }
}
