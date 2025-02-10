import 'dart:ui' as ui;

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
  (double, double) coord = (0.0, 0.0);
  (double, double)? maxCoord;
  AnimationDirection direction = AnimationDirection.RIGHT;

  /// Controllers
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.addListener(_updateUi);
      animationController.addStatusListener(_restartAnimation);
    });
  }

  void _updateUi() {
    if (maxCoord == null) return;

    if (direction.isRight) {
      coord = (maxCoord!.$1 * animationController.value, 0);
    } else if (direction.isDown) {
      coord = (coord.$1, animationController.value * maxCoord!.$2);
    } else if (direction.isLeft) {
      coord =
          (maxCoord!.$1 - (animationController.value * maxCoord!.$1), coord.$2);
    } else if (direction.isUp) {
      coord =
          (coord.$1, maxCoord!.$2 - (animationController.value * maxCoord!.$2));
    } else {
      throw Exception('something messed up');
    }

    if (animationController.value == 1) {
      direction = direction.toggle();
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

  @override
  void dispose() {
    animationController.removeListener(_updateUi);
    animationController.removeStatusListener(_restartAnimation);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      maxCoord = (constraints.maxWidth, constraints.maxHeight);
      return CustomPaint(
        painter: AnimateBorder(
          coord,
          strokeWidth: 4,
          glowRadius: 80,
          borderRadius:
              (widget.decoratedBox.borderRadius as BorderRadius).bottomLeft.x,
          shader: (actor, glowRadius) => ui.Gradient.radial(
            actor,
            glowRadius,
            [
              Colors.teal,
              Colors.transparent,
            ],
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: widget.decoratedBox,
          child: widget.label,
        ),
      );
    });
  }
}

class AnimateBorder extends CustomPainter {
  final (double, double) coord;
  final Color primaryColor;
  final double strokeWidth;
  final double borderRadius;
  final double? glowRadius;
  final Shader Function(Offset, double)? shader;

  const AnimateBorder(
    this.coord, {
    this.primaryColor = Colors.transparent,
    this.strokeWidth = 1,
    this.borderRadius = 0,
    this.glowRadius,
    this.shader,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// Constants
    final actor = Offset(coord.$1, coord.$2);

    /// Painter
    final paint = ui.Paint();
    paint.strokeWidth = strokeWidth;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    paint.shader = shader?.call(actor, glowRadius ?? size.height * 2) ??
        ui.Gradient.radial(
          actor,
          glowRadius ?? size.height * 2,
          [primaryColor, Colors.transparent],
        );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is AnimateBorder) {
      return oldDelegate.coord != coord;
    }
    return false;
  }
}
