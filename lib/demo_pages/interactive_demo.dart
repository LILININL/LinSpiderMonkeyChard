import 'package:flutter/material.dart';
import '../chard_kit_v2/chard_kit_v2.dart';

class InteractiveDemo extends StatefulWidget {
  final List<dynamic> groups;

  const InteractiveDemo({super.key, required this.groups});

  @override
  State<InteractiveDemo> createState() => _InteractiveDemoState();
}

class _InteractiveDemoState extends State<InteractiveDemo> {
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
      appBar: AppBar(title: const Text('Interactive Chart')),
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
                  labelDistance: 20,
                  bubbleOffset: 100,
                  showSelectedLabel: true,
                  showTitleSelectedLabel: true,
                  titleSelectedLabelTopOffset: 0.0,
                  chartTopOffset: 0.0,
                  titleSelectedLabelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedLabelStyle: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  lineColor: Colors.indigo,
                  fillColor: Color(0x333F51B5),
                  pointColor: Colors.indigo,
                  useGradient: true,
                  gradientColors: [Color(0x663F51B5), Color(0x333F51B5)],
                ),
              ),
            ),
          ),

          // Legend / Info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                Text(
                  'Tap on the chart points to see values',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
