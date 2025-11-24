import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/spider_chart.dart';
import 'widgets/score_bubble.dart';
import 'widgets/spider_chart_theme.dart';

class ChartDetailPageV2 extends StatefulWidget {
  /// The title displayed in the AppBar.
  final String title;

  /// The labels for the chart axes.
  final List<String> labels;

  /// The data values corresponding to each label.
  final List<double> data;

  /// The theme for the chart.
  final SpiderChartThemeData theme;

  /// The maximum value for the chart scale (default 100).
  final double maxValue;

  /// Whether to enable scrolling for the page content.
  final bool enableScroll;

  /// The width of the chart widget.
  final double chartWidth;

  /// The height of the chart widget.
  final double chartHeight;

  /// Whether to show the title text above the chart (the selected label name).
  final bool showTitleText;

  /// Whether to show labels on the chart itself.
  final bool showChartLabels;

  /// The initial index to select. If null, it will try to find the first non-zero value.
  final int? initialSelectedIndex;

  const ChartDetailPageV2({
    super.key,
    required this.title,
    required this.labels,
    required this.data,
    this.theme = const SpiderChartThemeData(),
    this.maxValue = 100,
    this.enableScroll = true,
    this.chartWidth = 350,
    this.chartHeight = 350,
    this.showTitleText = true,
    this.showChartLabels = true,
    this.initialSelectedIndex,
  });

  @override
  State<ChartDetailPageV2> createState() => _ChartDetailPageV2State();
}

class _ChartDetailPageV2State extends State<ChartDetailPageV2> {
  int? selectedIndex;
  Offset? bubbleOffset;

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    if (widget.initialSelectedIndex != null) {
      selectedIndex = widget.initialSelectedIndex;
      _calculateBubblePosition(selectedIndex!);
    } else if (widget.data.isNotEmpty) {
      // Find first index with score > 0
      int foundIndex = -1;
      for (int i = 0; i < widget.data.length; i++) {
        if (widget.data[i] > 0) {
          foundIndex = i;
          break;
        }
      }

      if (foundIndex != -1) {
        selectedIndex = foundIndex;
        _calculateBubblePosition(selectedIndex!);
      }
    }
  }

  void _calculateBubblePosition(int index) {
    // Calculate initial bubble position based on chart geometry
    // This is an approximation since we don't have the exact render size yet in initState
    // But for the initial state, we can estimate based on the provided chartWidth/Height
    final size = min(widget.chartWidth, widget.chartHeight);
    final center = size / 2;
    final radius = (size / 2) * 0.75;
    final labelRadius = radius + 25;
    final angleStep = (2 * pi) / widget.labels.length;
    const startAngle = -pi / 2;

    final angle = startAngle + (angleStep * index);
    final lx = center + labelRadius * cos(angle);
    final ly = center + labelRadius * sin(angle);
    bubbleOffset = Offset(lx, ly);
  }

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          if (widget.showTitleText)
            if (selectedIndex != null)
              Text(
                widget.labels[selectedIndex!],
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
            height: widget.chartHeight + 100, // Add space for bubble
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 60,
                  child: SizedBox(
                    width: widget.chartWidth,
                    height: widget.chartHeight,
                    child: SpiderChart(
                      labels: widget.labels,
                      data: widget.data,
                      maxValue: widget.maxValue,
                      theme: widget.theme,
                      showLabels: widget.showChartLabels,
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
                                      widget.chartWidth) /
                                  2 -
                              40 // Adjust for bubble width/2 and centering
                        : (MediaQuery.of(context).size.width / 2) -
                              40, // Center if no selection
                    top: bubbleOffset != null
                        ? bubbleOffset!.dy +
                              60 -
                              70 // Adjust for bubble height and chart top offset
                        : 0, // Top position if no selection
                    child: ScoreBubble(
                      score: widget.data[selectedIndex!],
                      color: widget.theme.lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: widget.enableScroll
          ? SingleChildScrollView(child: content)
          : content,
    );
  }
}
