import 'package:flutter/material.dart';
import 'package:lin_spider_monkey_chart/lin_spider_monkey_chart.dart';

class ListCardDemo extends StatelessWidget {
  final List<dynamic> groups;

  const ListCardDemo({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Card Demo')),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          final competencies = group['competencies'] as List;
          final labels = competencies.map((e) => e['name'] as String).toList();
          final data = competencies
              .map((e) => ((e['percentScore'] ?? 0) as num).toDouble())
              .toList();

          final avgScore = data.isEmpty
              ? 0.0
              : data.reduce((a, b) => a + b) / data.length;

          return ChartListCard(
            title: group['name'] ?? 'Unknown Group',
            scoreText: 'Avg Score: ${avgScore.toStringAsFixed(1)}',
            dateText: 'Updated: 24 Nov 2025',
            labels: labels,
            data: data,
            theme: const SpiderChartThemeData(
              dataLineColor: Colors.blue,
              dataFillColor: Color(0x332196F3),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on ${group['name']}')),
              );
            },
          );
        },
      ),
    );
  }
}
