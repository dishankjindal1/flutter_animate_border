import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AnimateBorderPainter extends CustomPainter {
  final List<Offset> actors;
  final double strokeWidth;
  final double radius;
  final Gradient gradient;

  const AnimateBorderPainter({
    required this.actors,
    required this.gradient,
    this.strokeWidth = 1,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    void drawActor(Offset actor) {
      /// Constants
      final paint = ui.Paint();
      paint.strokeWidth = strokeWidth;
      paint.strokeCap = StrokeCap.round;
      paint.style = PaintingStyle.stroke;

      final extendLine = 50;

      final path = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(radius),
          ),
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

      double startOffset = closestOffset - extendLine;
      double endOffset = closestOffset + extendLine;

      final Path segment = Path();
      if (startOffset < 0) {
        final remaining = totalLength + startOffset;
        final firstPath = metrics.extractPath(remaining, totalLength);
        final secondPath = metrics.extractPath(0, endOffset);
        segment.addPath(firstPath, Offset.zero);
        segment.addPath(secondPath, Offset.zero);
      } else if (endOffset > totalLength) {
        final firstPath = metrics.extractPath(startOffset, totalLength);
        final remaining = endOffset - totalLength;
        final secondPath = metrics.extractPath(0, remaining);
        segment.addPath(firstPath, Offset.zero);
        segment.addPath(secondPath, Offset.zero);
      } else {
        final path = metrics.extractPath(startOffset, endOffset);
        segment.addPath(path, Offset.zero);
      }

      //! TODO:@dishank - Find a linear gradient approach
      paint.shader = ui.Gradient.radial(
        actor,
        50,
        gradient.colors,
        gradient.stops,
      );

      canvas.drawPath(segment, paint);
    }

    for (var actor in actors) {
      drawActor(actor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is AnimateBorderPainter) {
      return oldDelegate.actors != actors;
    }
    return false;
  }
}
