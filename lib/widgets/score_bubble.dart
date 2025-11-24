import 'package:flutter/material.dart';
import 'triangle_clipper.dart';

class ScoreBubble extends StatelessWidget {
  final double score;
  final Color color;
  final String? label;
  final bool showLabel;

  const ScoreBubble({
    super.key,
    required this.score,
    this.color = const Color(0xFF7B4DFF),
    this.label,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
        ),
        Transform.translate(
          offset: const Offset(0, -1),
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(width: 20, height: 10, color: color),
          ),
        ),
      ],
    );
  }
}
