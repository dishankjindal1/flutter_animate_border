import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlutterAnimateBorder extends StatefulWidget {
  const FlutterAnimateBorder({
    required this.label,
    required this.decoratedBox,
    super.key,
  });

  final Widget label;
  final BoxDecoration decoratedBox;

  @override
  State<FlutterAnimateBorder> createState() => _FlutterAnimateBorderState();
}

class CustomCurve extends Curve {
  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) {
      return t;
    }

    return t;

    // if (t < 0.25) {
    //   return math.pow(math.sin(math.pi * t), 2).toDouble();
    // } else if (t < 0.5) {
    //   return math.pow(0.25 + math.sin(math.pi * t), 2).toDouble();
    // } else if (t < 0.75) {
    //   return math.pow(0.5 + math.sin(math.pi * t), 2).toDouble();
    // } else {
    //   return math.pow(0.75 + math.sin(math.pi * t), 2).toDouble();
    // }
  }
}

class _FlutterAnimateBorderState extends State<FlutterAnimateBorder>
    with SingleTickerProviderStateMixin {
  /// Mutable
  late Offset actor = Offset(0, 0);
  Offset box = Offset(0, 0);

  /// Immutable
  late double radius =
      (widget.decoratedBox.borderRadius as BorderRadius).bottomLeft.x;

  /// Controllers
  late final AnimationController animationController;
  late final Animation<double> animationValue;

  void _calculate() {
    final findTheMinSize = math.min(box.dx, box.dy);
    final maxCornerRadius = findTheMinSize / 2;
    final pickMinCornerRadius = math.min(radius, maxCornerRadius);

    radius = pickMinCornerRadius;
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    animationValue = animationController.drive(
      CurveTween(curve: CustomCurve()),
    );

    animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculate();
      animationController.addListener(_updateUi);
      animationController.addStatusListener(_restartAnimation);
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

        if (d < edgeH) {
          actor = Offset(box.dx, d + radius);
          return;
        }

        d -= edgeH;

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

        if (d < edgeH) {
          actor = Offset(0, box.dy - d - radius);
          return;
        }

        d -= edgeH;

        if (d < arc) {
          final angle = d / radius;
          actor = arcPoint(radius, radius, math.pi, angle);
          return;
        }

        d -= arc;
      });
    }
  }

  void _restartAnimation(AnimationStatus status) {
    if (status.isCompleted) {
      animationController.reset();
      animationController.forward();
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
  void dispose() {
    animationController.removeListener(_updateUi);
    animationController.removeStatusListener(_restartAnimation);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () async {
        animationController.reset();
        setState(() {
          /// refresh ui
        });
        animationController.forward();
      },
      child: LayoutBuilder(builder: (context, constraints) {
        box = Offset(constraints.maxWidth, constraints.maxHeight);
        return CustomPaint(
          willChange: kDebugMode,
          painter: AnimateBorder(
            [actor],
            strokeWidth: 2,
            borderRadius: radius,
            shader: (actor, glowRadius) => ui.Gradient.radial(
              actor,
              50,
              [Colors.teal, Colors.teal.withAlpha(50), Colors.transparent],
              [0, 0.75, 1],
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: widget.decoratedBox,
            child: widget.label,
          ),
        );
      }),
    );
  }
}

class AnimateBorder extends CustomPainter {
  final List<Offset> actors;
  final Color primaryColor;
  final double strokeWidth;
  final double borderRadius;
  final double? glowRadius;
  final Shader Function(Offset, double)? shader;

  const AnimateBorder(
    this.actors, {
    this.primaryColor = Colors.transparent,
    this.strokeWidth = 1,
    this.borderRadius = 0,
    this.glowRadius,
    this.shader,
  });

  @override
  void paint(Canvas canvas, Size size) {
    void drawActor(Offset actor) {
      /// Constants
      final paint = ui.Paint();
      paint.strokeWidth = strokeWidth;
      paint.strokeCap = StrokeCap.round;
      paint.style = PaintingStyle.stroke;
      paint.shader = shader?.call(actor, glowRadius ?? size.height / 2);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      );

      canvas.drawRRect(rrect, paint);
    }

    for (var actor in actors) {
      drawActor(actor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is AnimateBorder) {
      return oldDelegate.actors != actors;
    }
    return false;
  }
}
