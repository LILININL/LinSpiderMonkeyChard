import 'package:flutter/material.dart';
import 'spider_chart.dart';
import 'spider_chart_theme.dart';

class ChartCompactRow extends StatelessWidget {
  final String title;
  final double score;
  final List<String> labels;
  final List<double> data;
  final VoidCallback? onTap;
  final SpiderChartThemeData theme;
  final bool showTitle;
  final bool showScore;
  final bool showChart;
  final bool showChartLabels;

  const ChartCompactRow({
    super.key,
    required this.title,
    required this.score,
    required this.labels,
    required this.data,
    this.onTap,
    this.theme = const SpiderChartThemeData(),
    this.showTitle = true,
    this.showScore = true,
    this.showChart = true,
    this.showChartLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Mini Chart
            if (showChart) ...[
              SizedBox(
                width: 40,
                height: 40,
                child: SpiderChart(
                  labels: labels,
                  data: data,
                  maxValue: 100,
                  theme: theme.copyWith(strokeWidth: 1.5, pointSize: 2),
                  showLabels: showChartLabels,
                ),
              ),
              const SizedBox(width: 16),
            ],
            // Title
            if (showTitle)
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            // Score
            if (showScore) ...[
              if (showTitle) const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.dataLineColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  score.toStringAsFixed(1),
                  style: TextStyle(
                    color: theme.dataLineColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
