import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class customCirclePainter extends CustomPainter {

  customCirclePainter({super.repaint,});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [Color(0xff83F8FF), Color(0xff4FA0FF)],
      );
    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 75, paint);
    final paint4 = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width / 1.7, size.height / 1.7),
        [Color(0xffffffff).withOpacity(0.6), Colors.white.withOpacity(0)],
      );
    var path4 = Path()
      ..addArc(Rect.fromCircle(center: center, radius: 75), 3 * pi / 4, pi);
    canvas.drawPath(path4, paint4);
    final paint2 = Paint()..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width / 1.7, size.height / 1.7),
        [Color(0xffffffff).withOpacity(0.3), Colors.white.withOpacity(0)],
      );
    var path = Path()
      ..addArc(
          Rect.fromCircle(center: center, radius: 75), 7 * pi / 8, 3 * pi / 4);
    canvas.drawPath(path, paint2);

    final paint3 = Paint()..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width / 1.7, size.height / 1.7),
        [Color(0xffffffff).withOpacity(0.3), Colors.white.withOpacity(0)],
      );
    var path2 = Path()
      ..addArc(Rect.fromCircle(center: center, radius: 75), pi, pi / 2);
    canvas.drawPath(path2, paint3);
  }

  @override
  bool shouldRepaint(customCirclePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(customCirclePainter oldDelegate) => false;
}
