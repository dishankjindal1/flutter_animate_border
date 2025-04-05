import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// [DefaultPainter] is used to draw the line on the perimeter of the container
class DefaultPainter extends CustomPainter {
  /// [isRunning] -> draw the animation
  final bool isRunning;

  /// [actors] -> draw more then one dots #Upcoming feature
  final List<Offset> actors;

  /// [cornerRadius] -> determine the corner radius of the animating border
  final double cornerRadius;

  /// [lineThickness] -> determine the thickness of the animating border
  final double lineThickness;

  /// [lineWidth] -> determine the length of the animation line range
  final double lineWidth;

  /// [linePadding] -> line padding offset to determine the anchor
  final double linePadding;

  /// [gradient] -> determine the [Gradient] of the animating border
  final Gradient gradient;

  /// Constructor
  const DefaultPainter(
    this.isRunning, {
    required this.actors,
    required this.cornerRadius,
    required this.lineThickness,
    required this.lineWidth,
    required this.linePadding,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isRunning) return;

    void drawActor(Offset actor) {
      /// Constants
      final paint = ui.Paint();
      paint.strokeWidth = lineThickness;
      paint.strokeCap = StrokeCap.round;
      paint.style = PaintingStyle.stroke;

      final path =
          Path()..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Radius.circular(cornerRadius),
            ).inflate(linePadding / 2),
          );

      final metrics = path.computeMetrics().first;
      final totalLength = metrics.length;

      double closestOffset = 0.0;
      double minDistance = double.maxFinite;

      for (var offset = 0.0; offset <= totalLength; offset += 1) {
        final tangent = metrics.getTangentForOffset(offset);

        if (tangent == null) continue;

        final distance = (tangent.position - actor).distance;
        if (distance < minDistance) {
          minDistance = distance;
          closestOffset = offset;
        }
      }

      double startOffset = closestOffset - lineWidth;
      double endOffset = closestOffset + lineWidth;

      Offset gapOffset = Offset.zero;

      final Path segment = Path();
      if (startOffset < 0) {
        final remaining = totalLength + startOffset;
        final firstPath = metrics.extractPath(remaining, totalLength);
        final secondPath = metrics.extractPath(0, endOffset);
        segment.addPath(firstPath, gapOffset);
        segment.addPath(secondPath, gapOffset);
      } else if (endOffset > totalLength) {
        final firstPath = metrics.extractPath(startOffset, totalLength);
        final remaining = endOffset - totalLength;
        final secondPath = metrics.extractPath(0, remaining);
        segment.addPath(firstPath, gapOffset);
        segment.addPath(secondPath, gapOffset);
      } else {
        final path = metrics.extractPath(startOffset, endOffset);
        segment.addPath(path, gapOffset);
      }

      paint.shader = gradient.createShader(
        Rect.fromCenter(center: actor, width: size.width, height: size.height),
      );

      canvas.drawPath(segment, paint);
    }

    for (var actor in actors) {
      drawActor(actor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
