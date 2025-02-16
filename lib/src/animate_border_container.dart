import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate_border/src/controller/controller.dart';
import 'package:flutter_animate_border/src/painters/default_painter.dart';

/// [FlutterAnimateBorder] is the main widget which wrap around your content, it acts as a [Container] so you dont need to pass your own [Container] as a child. Instead pass the [DecoratedBox] and [Padding] property to the controller [FlutterAnimateBorderController]
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
          gradient = widget.controller.boxDecoration?.gradient;
          thickness =
              widget.controller.boxDecoration?.border?.bottom.width ??
              thickness;
          radius =
              (widget.controller.boxDecoration?.borderRadius as BorderRadius?)
                  ?.bottomLeft
                  .x ??
              0;
          final findTheMinSize = math.min(box.dx, box.dy);
          final maxCornerRadius = findTheMinSize / 2;
          final pickMinCornerRadius = math.min(radius, maxCornerRadius);
          radius = pickMinCornerRadius;

          if (widget.controller.boxDecoration?.shape == BoxShape.circle) {
            radius = maxCornerRadius;
          }
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
    });
  }

  // Helper function to calculate arc points
  Offset arcPoint(double cx, double cy, double startAngle, double angle) {
    final x = cx + radius * math.cos(startAngle + angle);

    final y = cy + radius * math.sin(startAngle + angle);

    return Offset(x, y);
  }

  void _updateUi() {
    if (!widget.controller.isLoading) {
      animationController.stop();
      return;
    }

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
      builder: (context, _) {
        if (widget.controller.isLoading && !animationController.isAnimating) {
          animationController.reset();
          animationController.repeat();
        }
        return CustomPaint(
          foregroundPainter:
              widget.controller.isLoading
                  ? DefaultPainter(
                    actors: [actor],
                    strokeWidth: thickness,
                    radius: radius,
                    lineExtent: widget.controller.lineExtent,
                    gradient: LinearGradient(
                      colors: widget.controller.colors ?? [],
                      stops: widget.controller.colorsStops ?? [],
                      tileMode: TileMode.mirror,
                    ),
                  )
                  : null,
          child: Container(
            key: globalKey,
            padding: widget.controller.padding,
            alignment: Alignment.center,
            decoration: widget.controller.boxDecoration,
            child: widget.child,
          ),
        );
      },
    );
  }
}
