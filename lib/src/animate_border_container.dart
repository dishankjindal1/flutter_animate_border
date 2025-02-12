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

enum AnimationDirection {
  RIGHT,
  DOWN,
  LEFT,
  UP;

  bool get isRight => this == RIGHT;
  bool get isDown => this == DOWN;
  bool get isLeft => this == LEFT;
  bool get isUp => this == UP;
  bool get isRightLeft => isRight || isLeft;
  bool get isUpDown => isUp || isDown;

  AnimationDirection toggle() => switch (this) {
        RIGHT => DOWN,
        DOWN => LEFT,
        LEFT => UP,
        UP => RIGHT,
      };
}

class _FlutterAnimateBorderState extends State<FlutterAnimateBorder>
    with SingleTickerProviderStateMixin {
  /// Mutable
  late (double, double) actor = (0, 0);
  (double, double)? boxSize;
  AnimationDirection direction = AnimationDirection.RIGHT;

  /// Immutable
  late double borderRadius =
      (widget.decoratedBox.borderRadius as BorderRadius).bottomLeft.x;

  /// Controllers
  late final AnimationController animationController;
  late final Animation<double> animationValue;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animationValue = animationController.drive(
      CurveTween(curve: Curves.linear),
    );

    animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateBorderRadius();
      actor = (borderRadius / 2, 0);
      animationController.addListener(_updateUi);
      animationController.addStatusListener(_restartAnimation);
    });
  }

  double _normalize(double val, double min, double max) {
    return (val - min) / (max - min);
  }

  double? lastValue;
  void _updateUi() {
    if (boxSize == null) return;

    if (direction.isRight) {
      if (actor.$1 >= boxSize!.$1 - borderRadius) {
        lastValue ??= animationValue.value;
        final goingRightDown = borderRadius *
            Tween<double>(begin: 0, end: 1)
                .transform(_normalize(animationValue.value, lastValue!, 1));

        actor = (actor.$1, goingRightDown);
      }
      actor = (
        borderRadius + ((boxSize!.$1 - borderRadius) * animationValue.value),
        actor.$2
      );
    } else if (direction.isDown) {
      if (actor.$2 >= boxSize!.$2 - borderRadius) {
        lastValue ??= animationValue.value;
        final goingDownLeft = borderRadius *
            Tween<double>(begin: 0, end: 1)
                .transform(_normalize(animationValue.value, lastValue!, 1));

        actor = (boxSize!.$1 - goingDownLeft, actor.$2);
      }

      actor = (
        actor.$1,
        borderRadius + (boxSize!.$2 - borderRadius) * animationValue.value
      );
    } else if (direction.isLeft) {
      if (borderRadius >= actor.$1) {
        lastValue ??= animationValue.value;
        final goingUpLeft = boxSize!.$2 -
            (borderRadius *
                Tween<double>(begin: 0, end: 1).transform(
                    _normalize(animationValue.value, lastValue!, 1)));

        actor = (actor.$1, goingUpLeft);
      }

      actor = (
        boxSize!.$1 -
            borderRadius -
            (animationValue.value * (boxSize!.$1 - borderRadius)),
        actor.$2
      );
    } else if (direction.isUp) {
      if (borderRadius >= actor.$2) {
        lastValue ??= animationValue.value;
        final goingUpRight = borderRadius *
            Tween<double>(begin: 0, end: 1)
                .transform(_normalize(animationValue.value, lastValue!, 1));

        actor = (goingUpRight, actor.$2);
      }

      actor = (
        actor.$1,
        boxSize!.$2 -
            borderRadius -
            ((boxSize!.$2 - borderRadius) * animationValue.value)
      );
    } else {
      throw Exception('something messed up');
    }

    if (animationValue.value == 1) {
      direction = direction.toggle();
      lastValue = null;
    }

    if (mounted) {
      setState(() {
        /// refresh ui
      });
    }
  }

  void _restartAnimation(AnimationStatus status) {
    if (status.isCompleted) {
      animationController.reset();
      animationController.forward();
    }
  }

  void _calculateBorderRadius() {
    final findTheMinSize = math.min(boxSize!.$1, boxSize!.$2);
    final maxCornerRadius = findTheMinSize / 2;
    final pickMinCornerRadius = math.min(borderRadius, maxCornerRadius);
    borderRadius = pickMinCornerRadius;
  }

  @override
  void didUpdateWidget(covariant FlutterAnimateBorder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.decoratedBox != widget.decoratedBox) {
      _calculateBorderRadius();
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
        actor = (borderRadius / 2, 0);
        direction = AnimationDirection.RIGHT;
        setState(() {});
        animationController.forward();
      },
      child: LayoutBuilder(builder: (context, constraints) {
        boxSize = (constraints.maxWidth, constraints.maxHeight);
        return CustomPaint(
          willChange: kDebugMode,
          painter: AnimateBorder(
            [actor],
            strokeWidth: 40,
            borderRadius: borderRadius,
            shader: (actor, glowRadius) => ui.Gradient.radial(
              actor,
              10,
              [
                Colors.teal,
                Colors.red,
                Colors.transparent,
              ],
              [0, 0.7, 1],
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
  final List<(double, double)> actors;
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
      final offset = Offset(actor.$1, actor.$2);

      drawActor(offset);
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
