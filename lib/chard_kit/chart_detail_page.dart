import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/spider_chart.dart';
import 'widgets/score_bubble.dart';

class ChartDetailPage extends StatefulWidget {
  final Future<Map<String, dynamic>> Function() onFetchData;
  final String title;

  const ChartDetailPage({
    super.key,
    required this.onFetchData,
    required this.title,
  });

  @override
  State<ChartDetailPage> createState() => _ChartDetailPageState();
}

class _ChartDetailPageState extends State<ChartDetailPage> {
  bool isLoading = true;
  List<String> labels = [];
  List<double> data = [];
  double averageScore = 0;
  int? selectedIndex;
  Offset? bubbleOffset;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final detail = await widget.onFetchData();

      if (mounted) {
        setState(() {
          if (detail.containsKey('competencies')) {
            final competencies = detail['competencies'] as List;
            labels = competencies.map((e) => e['name'] as String).toList();
            data = competencies
                .map((e) => ((e['percentScore'] ?? 0) as num).toDouble())
                .toList();

            if (data.isNotEmpty) {
              averageScore = data.reduce((a, b) => a + b) / data.length;

              // Find first index with score > 0
              int foundIndex = -1;
              for (int i = 0; i < data.length; i++) {
                if (data[i] > 0) {
                  foundIndex = i;
                  break;
                }
              }

              if (foundIndex != -1) {
                selectedIndex = foundIndex;
                // Calculate initial bubble position
                final size = 350.0;
                final center = size / 2;
                final radius = (size / 2) * 0.75;
                final labelRadius = radius + 25;
                final angleStep = (2 * pi) / labels.length;
                const startAngle = -pi / 2;

                final angle = startAngle + (angleStep * selectedIndex!);
                final lx = center + labelRadius * cos(angle);
                final ly = center + labelRadius * sin(angle);
                bubbleOffset = Offset(lx, ly);
              }
            }
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayScore = selectedIndex != null ? data[selectedIndex!] : 0.0;
    final displayLabel = selectedIndex != null ? labels[selectedIndex!] : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    if (selectedIndex != null)
                      Text(
                        displayLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else
                      const SizedBox(height: 27),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 450,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 60,
                            child: SizedBox(
                              width: 350,
                              height: 350,
                              child: SpiderChart(
                                labels: labels,
                                data: data,
                                maxValue: 100,
                                color: const Color(0xFF7B4DFF),
                                onLabelTap: (index, offset) {
                                  setState(() {
                                    selectedIndex = index;
                                    bubbleOffset = offset;
                                  });
                                },
                              ),
                            ),
                          ),
                          if (selectedIndex != null)
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              left: bubbleOffset != null
                                  ? bubbleOffset!.dx +
                                        (MediaQuery.of(context).size.width -
                                                350) /
                                            2 -
                                        40 // Adjust for bubble width/2 and centering
                                  : (MediaQuery.of(context).size.width / 2) -
                                        40, // Center if no selection
                              top: bubbleOffset != null
                                  ? bubbleOffset!.dy +
                                        60 -
                                        70 // Adjust for bubble height and chart top offset
                                  : 0, // Top position if no selection
                              child: ScoreBubble(score: displayScore),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}
