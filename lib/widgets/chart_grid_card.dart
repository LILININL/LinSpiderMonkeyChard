import 'package:flutter/material.dart';
import 'spider_chart.dart';
import 'spider_chart_theme.dart';

class ChartGridCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> labels;
  final List<double> data;
  final VoidCallback? onTap;
  final SpiderChartThemeData theme;
  final Color backgroundColor;
  final bool showTitle;
  final bool showSubtitle;
  final bool showChartLabels;

  const ChartGridCard({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.labels,
    required this.data,
    this.onTap,
    this.theme = const SpiderChartThemeData(),
    this.backgroundColor = Colors.white,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showChartLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showTitle)
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (showTitle && showSubtitle && subtitle.isNotEmpty)
                  const SizedBox(height: 4),
                if (showSubtitle && subtitle.isNotEmpty) ...[
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (showTitle || showSubtitle) const SizedBox(height: 12),
                Expanded(
                  child: SpiderChart(
                    labels: labels,
                    data: data,
                    maxValue: 100,
                    theme: theme,
                    showLabels: showChartLabels,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
