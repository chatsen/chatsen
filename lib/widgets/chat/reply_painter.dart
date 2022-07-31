import 'package:flutter/material.dart';

class ReplyPainter extends CustomPainter {
  final Color color;
  final double width;

  ReplyPainter({
    required this.color,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = width;

    var path = Path();
    path.moveTo(size.width / 3.0, size.height);
    path.conicTo(size.width / 3.0, size.height / 2.0, size.width, size.height / 2.0, 12.0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
