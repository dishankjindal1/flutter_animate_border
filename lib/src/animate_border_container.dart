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
    super.key,
  });

  /// This controller is used to control the behavior and look of the
  /// widget.
  final FlutterAnimateBorderController controller;

  /// Pass your [Text] widget or [Image] widget to it
  final Widget child;

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
          gradient = widget.controller.gradient;
          thickness = widget.controller.lineThickness;
          radius = widget.controller.cornerRadius;
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
      duration: widget.controller.loopDuration,
    );

    animationValue = animationController.drive(
      CurveTween(curve: widget.controller.loopCurve),
    );

    animationController.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculate();
      animationController.addListener(_updateUi);
      animationController.addStatusListener(_updateState);
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

  void _updateState(AnimationStatus status) {
    if (widget.controller.isRunning && !animationController.isAnimating) {
      animationController.reset();
      animationController.repeat();
    }
  }

  void _updateUi() {
    if (mounted) {
      setState(() {
        if (widget.controller.isRunning && !animationController.isAnimating) {
          animationController.reset();
          animationController.repeat();
        }

        if (!widget.controller.isRunning) {
          animationController.stop();
          return;
        }

        final adjustedWidth =
            (box.dx + 2 * widget.controller.linePadding)
                .clamp(0, double.infinity)
                .toDouble();
        final adjustedHeight =
            (box.dy + 2 * widget.controller.linePadding)
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
        final paddingOffset = widget.controller.linePaddingOffset;

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

    if (oldWidget.controller.hashCode != widget.controller.hashCode) {
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
    animationController.removeStatusListener(_updateState);
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

    return ListenableBuilder(
      listenable: Listenable.merge([widget.controller]),
      builder:
          (context, _) => CustomPaint(
            foregroundPainter:
                widget.controller.isRunning
                    ? DefaultPainter(
                      actors: [actor],
                      controller: widget.controller,
                    )
                    : null,
            child: Align(
              key: globalKey,
              alignment: Alignment.center,
              child: widget.child,
            ),
          ),
    );
  }
}
