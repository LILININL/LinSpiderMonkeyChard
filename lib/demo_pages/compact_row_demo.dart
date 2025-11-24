import 'package:flutter/material.dart';
import '../chard_kit_v2/chard_kit_v2.dart';

class CompactRowDemo extends StatelessWidget {
  final List<dynamic> groups;

  const CompactRowDemo({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compact Row Demo')),
      body: ListView.separated(
        itemCount: groups.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
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

          return ChartCompactRow(
            title: group['name'] ?? 'Unknown',
            score: avgScore,
            labels: labels,
            data: data,
            theme: const SpiderChartThemeData(
              lineColor: Colors.teal,
              fillColor: Color(0x33009688),
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
