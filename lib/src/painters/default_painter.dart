import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate_border/flutter_animate_border.dart';

/// [DefaultPainter] is used to draw the line on the perimeter of the
/// container
///
/// [actors] -> You can draw more then one dots #Upcoming feature
/// [controller] -> contains all the customizable options
class DefaultPainter extends CustomPainter {
  /// [actors] -> You can draw more then one dots #Upcoming feature
  final List<Offset> actors;

  /// [controller] -> contains all the customizable options
  final FlutterAnimateBorderController controller;

  /// Constructor
  const DefaultPainter({required this.actors, required this.controller});

  @override
  void paint(Canvas canvas, Size size) {
    void drawActor(Offset actor) {
      /// Constants
      final paint = ui.Paint();
      paint.strokeWidth = controller.lineThickness;
      paint.strokeCap = StrokeCap.round;
      paint.style = PaintingStyle.stroke;

      final path =
          Path()..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Radius.circular(controller.cornerRadius),
            ).inflate(controller.linePadding / 2),
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

      double startOffset = closestOffset - controller.lineWidth;
      double endOffset = closestOffset + controller.lineWidth;

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

      paint.shader = controller.gradient!.createShader(
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
