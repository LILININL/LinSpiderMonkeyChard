import 'package:flutter/material.dart';
import 'package:lin_spider_monkey_chart/lin_spider_monkey_chart.dart';

class GridCardDemo extends StatelessWidget {
  final List<dynamic> groups;

  const GridCardDemo({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Card Demo')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          final competencies = group['competencies'] as List;
          final labels = competencies.map((e) => e['name'] as String).toList();
          final data = competencies
              .map((e) => ((e['percentScore'] ?? 0) as num).toDouble())
              .toList();

          return ChartGridCard(
            title: group['name'] ?? 'Unknown',
            subtitle: '${labels.length} Competencies',
            labels: labels,
            data: data,
            theme: const SpiderChartThemeData(
              dataLineColor: Colors.purple,
              dataFillColor: Color(0x339C27B0),
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
