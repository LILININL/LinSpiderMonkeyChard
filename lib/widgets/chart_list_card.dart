import 'package:flutter/material.dart';
import 'spider_chart.dart';
import 'spider_chart_theme.dart';

class ChartListCard extends StatelessWidget {
  final String title;
  final String scoreText;
  final String dateText;
  final List<String> labels;
  final List<double> data;
  final VoidCallback? onTap;
  final SpiderChartThemeData theme;
  final Color backgroundColor;
  final bool showTitle;
  final bool showScore;
  final bool showDate;
  final bool showChart;
  final bool showArrow;
  final bool showChartLabels;

  const ChartListCard({
    super.key,
    required this.title,
    required this.scoreText,
    required this.dateText,
    required this.labels,
    required this.data,
    this.onTap,
    this.theme = const SpiderChartThemeData(),
    this.backgroundColor = Colors.white,
    this.showTitle = true,
    this.showScore = true,
    this.showDate = true,
    this.showChart = true,
    this.showArrow = true,
    this.showChartLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Chart Container
                if (showChart) ...[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.dataLineColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SpiderChart(
                      labels: labels,
                      data: data,
                      maxValue: 100,
                      theme: theme,
                      showLabels: showChartLabels,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showTitle)
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (showTitle && (showScore || showDate))
                        const SizedBox(height: 4),
                      if (showScore)
                        Text(
                          scoreText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (showScore && showDate) const SizedBox(height: 4),
                      if (showDate)
                        Text(
                          dateText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                if (showArrow) ...[
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.dataLineColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
