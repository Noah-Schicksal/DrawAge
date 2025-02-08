import 'package:flutter/material.dart';
import 'package:drawage/models/draw_point.dart';

class DrawPainter extends CustomPainter {
  final List<DrawPoint> points;

  DrawPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].position != null && points[i + 1].position != null) {
        canvas.drawLine(points[i].position!, points[i + 1].position!, points[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawPainter oldDelegate) => true;
}
