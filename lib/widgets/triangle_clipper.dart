import 'package:flutter/material.dart';

enum TriangleDirection { up, down }

class TriangleClipper extends CustomClipper<Path> {
  final TriangleDirection direction;

  TriangleClipper({this.direction = TriangleDirection.down});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (direction == TriangleDirection.down) {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TriangleClipper oldClipper) =>
      oldClipper.direction != direction;
}
