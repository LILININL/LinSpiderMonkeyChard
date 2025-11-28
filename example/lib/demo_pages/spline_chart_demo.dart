import 'package:flutter/material.dart';
import 'package:lin_spider_monkey_chart/lin_spider_monkey_chart.dart';

class SplineChartDemo extends StatefulWidget {
  final List<dynamic> groups;

  const SplineChartDemo({super.key, required this.groups});

  @override
  State<SplineChartDemo> createState() => _SplineChartDemoState();
}

class _SplineChartDemoState extends State<SplineChartDemo> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.groups.isEmpty) {
      return const Scaffold(body: Center(child: Text('No data available')));
    }

    final group = widget.groups[_selectedIndex];
    final competencies = group['competencies'] as List;
    final labels = competencies.map((e) => e['name'] as String).toList();
    final data = competencies
        .map((e) => ((e['percentScore'] ?? 0) as num).toDouble())
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Spline Chart Demo')),
      body: Column(
        children: [
          // Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: widget.groups.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(widget.groups[index]['name']),
                    selected: isSelected,
                    onSelected: (value) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Chart Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: InteractiveSpiderChart(
                labels: labels,
                data: data,
                maxValue: 100,
                size: Size.infinite,
                theme: const SpiderChartThemeData(
                  useSpline: true,
                  rotateToTop: false,
                  gridLineColor: Color(0xFFE0E0E0),
                  gridDashedLineColor: Color(0x337B4DFF),
                  spokeLineColor: Color(0xFFE0E0E0),
                  dataLineColor: Color(0xFF7B4DFF),
                  dataFillColor: Color(0x267B4DFF),
                  useGradient: true,
                  gradientColors: [Color(0x4D7B4DFF), Color(0x1A7B4DFF)],
                  centerCircleGradientColors: [
                    Color(0xFF9FA8DA),
                    Color(0xFF7B4DFF),
                  ],
                  pointColor: Color(0xFF7B4DFF),
                  pointSize: 6,
                  strokeWidth: 3,
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 12),
                  selectedLabelStyle: TextStyle(
                    color: Color(0xFF7B4DFF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  bubbleAnchor: BubbleAnchor.label,
                  autoTriangleDirection: true,
                  showTitleSelectedLabel: true,
                  titleSelectedLabelTopOffset: 0,
                  titleSelectedLabelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
