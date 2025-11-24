import 'dart:math';
import 'package:flutter/material.dart';

class SpiderChart extends StatelessWidget {
  final List<String> labels;
  final List<double> data;
  final double maxValue;
  final Color color;
  final Function(int, Offset)? onLabelTap;

  const SpiderChart({
    super.key,
    required this.labels,
    required this.data,
    this.maxValue = 100,
    this.color = Colors.deepPurple,
    this.onLabelTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTapUp: (details) {
            if (onLabelTap == null) return;
            _handleTap(details.localPosition, size);
          },
          child: CustomPaint(
            size: size,
            painter: _SpiderChartPainter(
              labels: labels,
              data: data,
              maxValue: maxValue,
              color: color,
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.75;
    final angleStep = (2 * pi) / labels.length;
    const startAngle = -pi / 2;

    for (int i = 0; i < labels.length; i++) {
      final angle = startAngle + (angleStep * i);
      final labelRadius = radius + 25;
      final lx = center.dx + labelRadius * cos(angle);
      final ly = center.dy + labelRadius * sin(angle);

      final labelPos = Offset(lx, ly);

      // Check if tap is near the label
      if ((localPosition - labelPos).distance < 40) {
        onLabelTap!(i, labelPos);
        return;
      }

      // Check if tap is near the data point (pointer)
      if (i < data.length) {
        final value = data[i] / maxValue;
        final r = radius * value;
        final px = center.dx + r * cos(angle);
        final py = center.dy + r * sin(angle);
        final pointPos = Offset(px, py);

        if ((localPosition - pointPos).distance < 30) {
          // Trigger same action as label tap, keeping bubble at label position
          onLabelTap!(i, labelPos);
          return;
        }
      }
    }
  }
}

class _SpiderChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> data;
  final double maxValue;
  final Color color;

  _SpiderChartPainter({
    required this.labels,
    required this.data,
    required this.maxValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.75;

    final paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paintGridDashed = Paint()
      ..color = Colors.deepPurple.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paintAxis = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, paintGrid);

    canvas.drawCircle(center, radius * 0.75, paintGrid);

    _drawDashedCircle(canvas, center, radius * 0.5, paintGridDashed);

    canvas.drawCircle(center, radius * 0.25, paintGrid);

    final angleStep = (2 * pi) / labels.length;

    const startAngle = -pi / 2;

    for (int i = 0; i < labels.length; i++) {
      final angle = startAngle + (angleStep * i);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.drawLine(center, Offset(x, y), paintAxis);

      final labelRadius = radius + 25;
      final lx = center.dx + labelRadius * cos(angle);
      final ly = center.dy + labelRadius * sin(angle);

      _drawText(canvas, labels[i], Offset(lx, ly), size);
    }

    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.blue.withOpacity(0.8), Colors.purple.withOpacity(0.8)],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.15));
    canvas.drawCircle(center, radius * 0.15, gradientPaint);

    if (data.isEmpty) return;

    final path = Path();
    final paintData = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final points = <Offset>[];

    for (int i = 0; i < labels.length; i++) {
      final value = (i < data.length ? data[i] : 0) / maxValue;
      final angle = startAngle + (angleStep * i);
      final r = radius * value;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintData);

    for (final point in points) {
      canvas.drawCircle(point, 4, Paint()..color = color);
    }
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    const dashWidth = 5;
    const dashSpace = 5;
    final circumference = 2 * pi * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final angleStep = (2 * pi) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final angle = i * angleStep;
      final x1 = center.dx + radius * cos(angle);
      final y1 = center.dy + radius * sin(angle);
      final x2 = center.dx + radius * cos(angle + angleStep * 0.5);
      final y2 = center.dy + radius * sin(angle + angleStep * 0.5);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 2,
    );
    textPainter.layout(maxWidth: 80);

    final dx = offset.dx - textPainter.width / 2;
    final dy = offset.dy - textPainter.height / 2;

    textPainter.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
