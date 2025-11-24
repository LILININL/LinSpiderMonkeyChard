import 'package:flutter/material.dart';
import 'triangle_clipper.dart';

class ScoreBubble extends StatelessWidget {
  final double score;
  final Color color;

  const ScoreBubble({
    super.key,
    required this.score,
    this.color = const Color(0xFF7B4DFF),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            score.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
