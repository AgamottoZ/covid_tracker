import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [Color(0xFF9339EE), Color(0xFF0844DC)];
    final gradient = LinearGradient(
        colors: colors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    var paint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(
          Offset(0, 0), Offset(size.height * 0.8, size.width / 2)));
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [Color(0xFF9339EE), Color(0xFF0844DC)];
    final gradient = LinearGradient(
        colors: colors,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);
    var paint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(
          Offset(0, 0), Offset(size.height * 0.8, size.width / 2)));
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.25, -10, size.width / 2, size.height * 0.08);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.2, size.width, size.height * 0.05);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
