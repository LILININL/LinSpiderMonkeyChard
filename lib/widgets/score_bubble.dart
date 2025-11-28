import 'package:flutter/material.dart';
import 'triangle_clipper.dart';

class ScoreBubble extends StatelessWidget {
  final double score;
  final Color color;
  final String? label;
  final bool showLabel;
  final TriangleDirection triangleDirection;
  final bool hideTriangle;

  const ScoreBubble({
    super.key,
    required this.score,
    this.color = const Color(0xFF7B4DFF),
    this.label,
    this.showLabel = false,
    this.triangleDirection = TriangleDirection.down,
    this.hideTriangle = false,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLabel && label != null) ...[
            Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
          ],
          Text(
            score.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    final triangle = Transform.translate(
      offset: Offset(0, triangleDirection == TriangleDirection.down ? -1 : 1),
      child: ClipPath(
        clipper: TriangleClipper(direction: triangleDirection),
        child: Container(width: 20, height: 10, color: color),
      ),
    );

    if (hideTriangle) return bubble;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: triangleDirection == TriangleDirection.down
          ? [bubble, triangle]
          : [triangle, bubble],
    );
  }
}
