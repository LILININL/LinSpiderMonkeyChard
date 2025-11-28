import 'dart:math';
import 'package:flutter/material.dart';
import 'spider_chart.dart';
import 'score_bubble.dart';
import 'spider_chart_theme.dart';
import 'triangle_clipper.dart';

class InteractiveSpiderChart extends StatefulWidget {
  final List<String> labels;
  final List<double?> data;
  final double maxValue;
  final SpiderChartThemeData theme;
  final bool showLabels;
  final int? initialSelectedIndex;
  final Size size;

  const InteractiveSpiderChart({
    super.key,
    List<String>? labels,
    List<double?>? data,
    this.maxValue = 100,
    this.theme = const SpiderChartThemeData(),
    this.showLabels = true,
    this.initialSelectedIndex,
    this.size = const Size(350, 350),
  }) : labels = labels ?? const [],
       data = data ?? const [];

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
        if ((widget.data[i] ?? 0) > 0) {
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
    if (widget.labels.isEmpty) return Offset.zero;

    final centerX = chartSize.width / 2;
    final centerY = chartSize.height / 2;
    final radius = min(chartSize.width, chartSize.height) / 2 * 0.85;

    double targetRadius;
    if (widget.theme.bubbleAnchor == BubbleAnchor.dataPoint) {
      final value =
          (index < widget.data.length ? (widget.data[index] ?? 0) : 0) /
          widget.maxValue;
      targetRadius = radius * value;
    } else {
      targetRadius = radius + widget.theme.labelOffsetFromChart;
    }

    final angleStep = (2 * pi) / widget.labels.length;
    const startAngle = -pi / 2;

    final angle = startAngle + (angleStep * index);
    final labelX = centerX + targetRadius * cos(angle);
    final labelY = centerY + targetRadius * sin(angle);
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
        final radius = min(width, height) / 2 * 0.85;

        Offset? bubbleOffset;
        TriangleDirection currentTriangleDirection =
            widget.theme.triangleDirection;

        if (!widget.theme.rotateToTop &&
            selectedIndex != null &&
            widget.labels.isNotEmpty) {
          bubbleOffset = _calculateBubblePosition(selectedIndex!, chartSize);

          if (widget.theme.autoTriangleDirection) {
            final angleStep = (2 * pi) / widget.labels.length;
            final angle = (-pi / 2) + (angleStep * selectedIndex!);
            // Normalize angle to 0..2pi
            double normalizedAngle = angle % (2 * pi);
            if (normalizedAngle < 0) normalizedAngle += 2 * pi;

            // If angle is in the bottom half (0 to pi), point up.
            // Top half (pi to 2pi or -pi to 0), point down.
            // Note: -pi/2 is top. 0 is right. pi/2 is bottom. pi is left.
            // So bottom half is roughly 0 to pi in standard math, but here -pi/2 is top.
            // Let's check sin(angle).
            // sin(-pi/2) = -1 (top). sin(pi/2) = 1 (bottom).
            // So if sin(angle) > 0, it's in the bottom half.
            if (sin(angle) > 0) {
              currentTriangleDirection = TriangleDirection.up;
            } else {
              currentTriangleDirection = TriangleDirection.down;
            }
          }
        }

        // Calculate top position for rotateToTop case
        double rotateToTopTop = 0;
        if (widget.theme.rotateToTop &&
            selectedIndex != null &&
            widget.labels.isNotEmpty) {
          double targetRadius;
          if (widget.theme.bubbleAnchor == BubbleAnchor.dataPoint) {
            final value =
                (selectedIndex! < widget.data.length
                    ? (widget.data[selectedIndex!] ?? 0)
                    : 0) /
                widget.maxValue;
            targetRadius = radius * value;
          } else {
            targetRadius = radius + widget.theme.labelOffsetFromChart;
          }
          // When rotated to top, the point is at -pi/2 (top).
          // Center Y is height/2. Top is height/2 - radius.
          // So position is center - targetRadius.
          rotateToTopTop =
              widget.theme.chartTopOffset + (height / 2) - targetRadius;
        }

        return SizedBox(
          width: width,
          height: height, // Removed + 100 to avoid eating up space
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
                      selectedIndex != null &&
                      widget.labels.isNotEmpty)
                    Positioned(
                      top:
                          (height / 2) -
                          radius -
                          100 +
                          widget.theme.titleSelectedLabelTopOffset,
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
                  if (selectedIndex != null && widget.labels.isNotEmpty)
                    widget.theme.rotateToTop
                        ? Positioned(
                            left: width / 2,
                            top: rotateToTopTop,
                            child: FractionalTranslation(
                              translation: const Offset(-0.5, -1.0),
                              child: ScoreBubble(
                                score:
                                    (selectedIndex! < widget.data.length
                                        ? widget.data[selectedIndex!]
                                        : 0) ??
                                    0,
                                color: widget.theme.dataLineColor,
                                triangleDirection:
                                    widget.theme.triangleDirection,
                              ),
                            ),
                          )
                        : AnimatedPositioned(
                            duration: widget.theme.rotationDuration,
                            curve: Curves.easeInOut,
                            left: bubbleOffset != null
                                ? bubbleOffset.dx
                                : width / 2,
                            top: bubbleOffset != null
                                ? bubbleOffset.dy + widget.theme.chartTopOffset
                                : 0,
                            child: TweenAnimationBuilder<double>(
                              duration: widget.theme.rotationDuration,
                              curve: Curves.easeInOut,
                              tween: Tween<double>(
                                end:
                                    currentTriangleDirection ==
                                        TriangleDirection.down
                                    ? 0.0
                                    : 1.0,
                              ),
                              builder: (context, value, child) {
                                return FractionalTranslation(
                                  translation: Offset(-0.5, -1.0 + value),
                                  child: Transform.translate(
                                    offset: Offset(0, -10.0 + (20.0 * value)),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ScoreBubble(
                                          score:
                                              (selectedIndex! <
                                                      widget.data.length
                                                  ? widget.data[selectedIndex!]
                                                  : 0) ??
                                              0,
                                          color: widget.theme.dataLineColor,
                                          hideTriangle: true,
                                        ),
                                        Positioned.fill(
                                          child: CustomSingleChildLayout(
                                            delegate: _TrianglePositionDelegate(
                                              progress: value,
                                            ),
                                            child: Transform.scale(
                                              scaleY: 1.0 - (2.0 * value),
                                              alignment: Alignment.center,
                                              child: ClipPath(
                                                clipper: TriangleClipper(
                                                  direction:
                                                      TriangleDirection.down,
                                                ),
                                                child: Container(
                                                  width: 20,
                                                  height: 10,
                                                  color: widget
                                                      .theme
                                                      .dataLineColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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

class _TrianglePositionDelegate extends SingleChildLayoutDelegate {
  final double progress;

  _TrianglePositionDelegate({required this.progress});

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // progress 0.0 -> Bottom (y = size.height)
    // progress 1.0 -> Top (y = -childSize.height)
    final double y =
        size.height * (1.0 - progress) - (childSize.height * progress);
    final double x = (size.width - childSize.width) / 2;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_TrianglePositionDelegate oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
