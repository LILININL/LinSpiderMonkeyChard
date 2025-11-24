import 'dart:math';
import 'package:flutter/material.dart';
import 'spider_chart.dart';
import 'score_bubble.dart';
import 'spider_chart_theme.dart';

class InteractiveSpiderChart extends StatefulWidget {
  final List<String> labels;
  final List<double> data;
  final double maxValue;
  final SpiderChartThemeData theme;
  final bool showLabels;
  final int? initialSelectedIndex;
  final Size size;

  const InteractiveSpiderChart({
    super.key,
    required this.labels,
    required this.data,
    this.maxValue = 100,
    this.theme = const SpiderChartThemeData(),
    this.showLabels = true,
    this.initialSelectedIndex,
    this.size = const Size(350, 350),
  });

  @override
  State<InteractiveSpiderChart> createState() => _InteractiveSpiderChartState();
}

class _InteractiveSpiderChartState extends State<InteractiveSpiderChart> {
  int? selectedIndex;
  double _targetRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    if (widget.initialSelectedIndex != null) {
      selectedIndex = widget.initialSelectedIndex;
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
      }
    }

    if (selectedIndex != null &&
        widget.labels.isNotEmpty &&
        widget.theme.rotateToTop) {
      final angleStep = (2 * pi) / widget.labels.length;
      _targetRotation = -(selectedIndex! * angleStep);
    }
  }

  Offset _calculateBubblePosition(int index, Size chartSize) {
    final size = min(chartSize.width, chartSize.height);
    final center = size / 2;
    final radius = (size / 2) * 0.75;
    final labelRadius = radius + widget.theme.labelOffsetFromChart;
    final angleStep = (2 * pi) / widget.labels.length;
    const startAngle = -pi / 2;

    final angle = startAngle + (angleStep * index);
    final labelX = center + labelRadius * cos(angle);
    final labelY = center + labelRadius * sin(angle);
    return Offset(labelX, labelY);
  }

  void _updateSelection(int index) {
    setState(() {
      selectedIndex = index;

      if (widget.theme.rotateToTop) {
        final angleStep = (2 * pi) / widget.labels.length;
        final target = -(index * angleStep);

        // Shortest path logic
        double diff = target - _targetRotation;
        while (diff < -pi) {
          diff += 2 * pi;
        }
        while (diff > pi) {
          diff -= 2 * pi;
        }

        _targetRotation += diff;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the available size for the chart
        double width = widget.size.width;
        double height = widget.size.height;

        // If size is infinite, use parent constraints
        if (width.isInfinite) width = constraints.maxWidth;
        if (height.isInfinite) {
          // If height is infinite, we try to use maxHeight.
          // We subtract 100 to account for the bubble space we add below,
          // effectively making the chart fit within the available space.
          height = constraints.maxHeight - 100;
        }

        // Fallback if still infinite or invalid
        if (width.isInfinite || width <= 0) width = 300;
        if (height.isInfinite || height <= 0) height = 300;

        final chartSize = Size(width, height);
        final radius = min(width, height) / 2 * 0.75;

        Offset? bubbleOffset;
        if (!widget.theme.rotateToTop && selectedIndex != null) {
          bubbleOffset = _calculateBubblePosition(selectedIndex!, chartSize);
        }

        return SizedBox(
          width: width,
          height: height + 100, // Add space for bubble
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: _targetRotation),
            duration: widget.theme.rotationDuration,
            curve: Curves.easeInOut,
            builder: (context, rotation, child) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (widget.theme.showTitleSelectedLabel &&
                      selectedIndex != null)
                    Positioned(
                      top: widget.theme.titleSelectedLabelTopOffset,
                      left: 16,
                      right: 16,
                      child: Text(
                        widget.labels[selectedIndex!],
                        style: widget.theme.titleSelectedLabelStyle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Positioned(
                    top: widget.theme.chartTopOffset,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: SpiderChart(
                        labels: widget.labels,
                        data: widget.data,
                        maxValue: widget.maxValue,
                        theme: widget.theme,
                        showLabels: widget.showLabels,
                        selectedIndex: selectedIndex,
                        rotationAngle: rotation,
                        onLabelTap: (index, offset) {
                          _updateSelection(index);
                        },
                      ),
                    ),
                  ),
                  if (selectedIndex != null)
                    widget.theme.rotateToTop
                        ? Positioned(
                            left:
                                (width / 2) - 40, // Center bubble (width 80/2)
                            top:
                                widget.theme.chartTopOffset +
                                (height / 2) -
                                radius -
                                widget.theme.bubbleOffset,
                            child: ScoreBubble(
                              score: widget.data[selectedIndex!],
                              color: widget.theme.dataLineColor,
                            ),
                          )
                        : AnimatedPositioned(
                            duration: widget.theme.rotationDuration,
                            curve: Curves.easeInOut,
                            left: bubbleOffset != null
                                ? bubbleOffset.dx - 40
                                : (width / 2) - 40,
                            top: bubbleOffset != null
                                ? bubbleOffset.dy +
                                      widget.theme.chartTopOffset -
                                      widget.theme.bubbleOffset
                                : 0,
                            child: ScoreBubble(
                              score: widget.data[selectedIndex!],
                              color: widget.theme.dataLineColor,
                            ),
                          ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
