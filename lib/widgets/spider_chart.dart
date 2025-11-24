import 'dart:math';
import 'package:flutter/material.dart';
import 'spider_chart_theme.dart';

class SpiderChart extends StatelessWidget {
  final List<String> labels;
  final List<double> data;
  final double maxValue;
  final SpiderChartThemeData theme;
  final Function(int, Offset)? onLabelTap;
  final bool showLabels;
  final int? selectedIndex;
  final double rotationAngle;

  const SpiderChart({
    super.key,
    required this.labels,
    required this.data,
    this.maxValue = 100,
    this.theme = const SpiderChartThemeData(),
    this.onLabelTap,
    this.showLabels = true,
    this.selectedIndex,
    this.rotationAngle = 0.0,
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
              theme: theme,
              showLabels: showLabels,
              selectedIndex: selectedIndex,
              rotationAngle: rotationAngle,
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
    final startAngle = -pi / 2 + rotationAngle;

    for (int i = 0; i < labels.length; i++) {
      final angle = startAngle + (angleStep * i);
      final labelRadius = radius + theme.labelOffsetFromChart;
      final labelX = center.dx + labelRadius * cos(angle);
      final labelY = center.dy + labelRadius * sin(angle);

      final labelPos = Offset(labelX, labelY);

      // Check if tap is near the label
      if ((localPosition - labelPos).distance < 40) {
        onLabelTap!(i, labelPos);
        return;
      }

      // Check if tap is near the data point (pointer)
      if (i < data.length) {
        final value = data[i] / maxValue;
        final pointRadius = radius * value;
        final pointX = center.dx + pointRadius * cos(angle);
        final pointY = center.dy + pointRadius * sin(angle);
        final pointPos = Offset(pointX, pointY);

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
  final SpiderChartThemeData theme;
  final bool showLabels;
  final int? selectedIndex;
  final double rotationAngle;

  _SpiderChartPainter({
    required this.labels,
    required this.data,
    required this.maxValue,
    required this.theme,
    required this.showLabels,
    this.selectedIndex,
    this.rotationAngle = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.75;

    final paintGrid = Paint()
      ..color = theme.gridLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paintGridDashed = Paint()
      ..color = theme.gridDashedLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paintAxis = Paint()
      ..color = theme.spokeLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, paintGrid);

    canvas.drawCircle(center, radius * 0.75, paintGrid);

    _drawDashedCircle(canvas, center, radius * 0.5, paintGridDashed);

    canvas.drawCircle(center, radius * 0.25, paintGrid);

    final angleStep = (2 * pi) / labels.length;

    final startAngle = -pi / 2 + rotationAngle;

    for (int i = 0; i < labels.length; i++) {
      final angle = startAngle + (angleStep * i);
      final axisEndX = center.dx + radius * cos(angle);
      final axisEndY = center.dy + radius * sin(angle);

      canvas.drawLine(center, Offset(axisEndX, axisEndY), paintAxis);

      final labelRadius = radius + theme.labelOffsetFromChart;
      final labelX = center.dx + labelRadius * cos(angle);
      final labelY = center.dy + labelRadius * sin(angle);

      final isSelected = i == selectedIndex;
      final shouldHighlight = isSelected && theme.showSelectedLabel;

      if (showLabels || shouldHighlight) {
        final style = shouldHighlight
            ? theme.selectedLabelStyle
            : theme.labelStyle;
        _drawText(canvas, labels[i], Offset(labelX, labelY), size, style);
      }
    }

    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blue.withValues(alpha: 0.8),
          Colors.purple.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.15));
    canvas.drawCircle(center, radius * 0.15, gradientPaint);

    if (data.isEmpty) return;

    final path = Path();
    final paintData = Paint()
      ..color = theme.dataLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = theme.strokeWidth
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()..style = PaintingStyle.fill;

    if (theme.useGradient && theme.gradientColors != null) {
      paintFill.shader = RadialGradient(
        colors: theme.gradientColors!,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      paintFill.color = theme.dataFillColor;
    }

    final points = <Offset>[];

    for (int i = 0; i < labels.length; i++) {
      final value = (i < data.length ? data[i] : 0) / maxValue;
      final angle = startAngle + (angleStep * i);
      final dataPointRadius = radius * value;
      final dataPointX = center.dx + dataPointRadius * cos(angle);
      final dataPointY = center.dy + dataPointRadius * sin(angle);
      points.add(Offset(dataPointX, dataPointY));

      if (i == 0) {
        path.moveTo(dataPointX, dataPointY);
      } else {
        path.lineTo(dataPointX, dataPointY);
      }
    }
    path.close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintData);

    for (final point in points) {
      canvas.drawCircle(
        point,
        theme.pointSize,
        Paint()..color = theme.pointColor,
      );
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

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Size size,
    TextStyle style,
  ) {
    final textSpan = TextSpan(text: text, style: style);
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
