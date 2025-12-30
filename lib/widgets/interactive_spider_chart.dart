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
  })  : labels = labels ?? const [],
        data = data ?? const [];

  @override
  State<InteractiveSpiderChart> createState() => _InteractiveSpiderChartState();
}

class _InteractiveSpiderChartState extends State<InteractiveSpiderChart> {
  int? selectedIndex;
  double _targetRotation = 0.0;
  bool _lastTitleVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    if (widget.initialSelectedIndex != null) {
      selectedIndex = widget.initialSelectedIndex;
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
    final radius = min(chartSize.width, chartSize.height) / 2 * 0.90;

    double targetRadius;
    if (widget.theme.bubbleAnchor == BubbleAnchor.dataPoint) {
      final value =
          (index < widget.data.length ? (widget.data[index] ?? 0) : 0) /
              widget.maxValue;
      targetRadius = radius * value;
    } else {
      targetRadius = (radius + widget.theme.labelOffsetFromChart) *
          widget.theme.labelRadiusFactor;
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
      final isSameSelection = selectedIndex == index;

      if (widget.theme.titleLabelBehavior == TitleLabelBehavior.toggleOnTap &&
          isSameSelection) {
        selectedIndex = null;
        return;
      }

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
        // 1. Determine available width/height from constraints
        double width = constraints.maxHeight.isFinite
            ? constraints.maxWidth
            : widget.size.width;
        double height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : widget.size.height;

        // 2. Fallback for infinite/unbounded cases
        if (width.isInfinite) width = 320;
        if (height.isInfinite) height = 320;

        // Ensure we stay within constraints if they are bounded
        width = width.clamp(0.0, constraints.maxWidth);
        height = height.clamp(0.0, constraints.maxHeight);

        final bool isTitleVisible =
            widget.theme.titleLabelMode == TitleLabelMode.shown &&
                selectedIndex != null &&
                widget.labels.isNotEmpty;
        final bool shouldAnimateTitle = isTitleVisible && !_lastTitleVisible;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _lastTitleVisible = isTitleVisible;
        });

        final double titleSpace = widget.theme.titleSlideSpace;
        // logic: if title is visible, we might want to reserve space or slide things?
        // But for "fit to parent", we usually want the chart to be centered in the available space.
        // If enableTitleSlide is on, we might shift the chart down.

        final Duration slideDuration = widget.theme.enableTitleSlide
            ? widget.theme.titleSlideDuration
            : Duration.zero;
        final Duration titleSwitchDuration =
            shouldAnimateTitle ? slideDuration : Duration.zero;
        final Curve slideCurve = widget.theme.titleSlideCurve;
        final double slideOffset = shouldAnimateTitle ? -0.2 : 0.0;

        // Calculate chart area size

        // SELF-CONTAINED LOGIC:
        final double extraTitleSpace = isTitleVisible ? titleSpace : 0.0;

        // 1. Chart Top moves down to make room for title
        final double activeChartTop =
            widget.theme.chartTopOffset + extraTitleSpace;

        // 2. Available height for the spider chart itself is reduced
        final double availableChartHeight = height - extraTitleSpace;

        // 3. Radius is calculated based on the SMALLER of width or availableHeight
        // Note: We use availableChartHeight here so the chart shrinks to fit
        final radius = min(width, availableChartHeight) / 2 * 90;

        final chartSize = Size(width, availableChartHeight);

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
            double normalizedAngle = angle % (2 * pi);
            if (normalizedAngle < 0) normalizedAngle += 2 * pi;

            if (sin(angle) > 0) {
              currentTriangleDirection = TriangleDirection.up;
            } else {
              currentTriangleDirection = TriangleDirection.down;
            }
          }
        }

        double rotateToTopTop = 0;
        if (widget.theme.rotateToTop &&
            selectedIndex != null &&
            widget.labels.isNotEmpty) {
          double targetRadius;
          if (widget.theme.bubbleAnchor == BubbleAnchor.dataPoint) {
            final value = (selectedIndex! < widget.data.length
                    ? (widget.data[selectedIndex!] ?? 0)
                    : 0) /
                widget.maxValue;
            targetRadius = radius * value;
          } else {
            targetRadius = radius + widget.theme.labelOffsetFromChart;
          }
          // Center Y is availableChartHeight/2. Top is availableChartHeight/2 - radius.
          rotateToTopTop =
              activeChartTop + (availableChartHeight / 2) - targetRadius;
        }

        double bottomOverflow = 0.0;
        if (!widget.theme.rotateToTop &&
            selectedIndex != null &&
            widget.labels.isNotEmpty) {
          // Calculate if bubble overflows bottom
          if (bubbleOffset != null) {
            final double bubbleY = activeChartTop + bubbleOffset.dy;

            // Use bottomPadding as the estimated height/space needed for the bubble
            final double estimatedBubbleHeight = widget.theme.bottomPadding;

            double bubbleBottomY;
            if (currentTriangleDirection == TriangleDirection.up) {
              // Point is up, body is down. bubbleOffset is tip.
              bubbleBottomY = bubbleY + estimatedBubbleHeight;
            } else {
              // Point is down, body is up. bubbleOffset is tip.
              bubbleBottomY = bubbleY;
            }

            // Only calculate overflow if autoHeightAdjustment is enabled
            if (widget.theme.autoHeightAdjustment) {
              // Check against total frame height
              if (bubbleBottomY > height) {
                bottomOverflow = bubbleBottomY - height;
              }
            }
          }
        }

        // Logic fix for Title Position:
        // Anchored at the top of the actual chart (activeChartTop).
        // user's titleSelectedLabelTopOffset "moves it up" -> so we subtract.
        final double titleTopPosition =
            activeChartTop - widget.theme.titleSelectedLabelTopOffset;

        // Height calculation in AnimatedContainer
        // We do NOT add extraTitleSpace here anymore.
        // We only add bottomOverflow if auto-adjustment is on.
        final double containerHeight = height + bottomOverflow;

        return AnimatedContainer(
          duration: slideDuration,
          curve: slideCurve,
          width: width,
          height: containerHeight,
          child: Stack(
            alignment: Alignment.center, // Main stack center
            clipBehavior: Clip.none,
            children: [
              // Title Label
              Positioned(
                top: titleTopPosition,
                left: 16,
                right: 16,
                child: AnimatedSwitcher(
                  duration: titleSwitchDuration,
                  layoutBuilder: (currentChild, previousChildren) {
                    return currentChild ?? const SizedBox.shrink();
                  },
                  transitionBuilder: (child, animation) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: widget.theme.titleSlideCurve,
                    );
                    return FadeTransition(
                      opacity: curved,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, slideOffset),
                          end: Offset.zero,
                        ).animate(curved),
                        child: child,
                      ),
                    );
                  },
                  child: isTitleVisible
                      ? Text(
                          widget.labels[selectedIndex!],
                          key: ValueKey<int?>(selectedIndex),
                          style: widget.theme.titleSelectedLabelStyle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : const SizedBox.shrink(
                          key: ValueKey<String>('no-title'),
                        ),
                ),
              ),

              // The Chart itself
              AnimatedPositioned(
                duration: slideDuration,
                curve: slideCurve,
                top: activeChartTop,
                left: 0,
                right: 0,
                // We use specific width/height for the chart container
                height: availableChartHeight,
                child: Center(
                  child: SizedBox(
                    width: width,
                    height: availableChartHeight,
                    child: TweenAnimationBuilder<double>(
                        tween: Tween(end: _targetRotation),
                        duration: widget.theme.rotationDuration,
                        curve: Curves
                            .easeInOut, // Apply rotation curve here too if needed
                        builder: (context, rotation, child) {
                          return SpiderChart(
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
                          );
                        }),
                  ),
                ),
              ),

              // Bubbles
              if (selectedIndex != null && widget.labels.isNotEmpty)
                widget.theme.rotateToTop
                    ? Positioned(
                        left: (width / 2), // relative to container
                        top: rotateToTopTop,
                        child: FractionalTranslation(
                          translation: const Offset(-0.5, -1.0),
                          child: ScoreBubble(
                            score: (selectedIndex! < widget.data.length
                                    ? widget.data[selectedIndex!]
                                    : 0) ??
                                0,
                            color: widget.theme.dataLineColor,
                            triangleDirection: widget.theme.triangleDirection,
                          ),
                        ),
                      )
                    : AnimatedPositioned(
                        duration: widget.theme.rotationDuration,
                        curve: Curves.easeInOut, // match rotation
                        left: bubbleOffset != null
                            ? bubbleOffset.dx
                            // If bubbleOffset is null (shouldn't happen if logic correct), center
                            : (width / 2),

                        // Add activeChartTop to Y because the Chart is shifted down by that amount
                        top: (bubbleOffset != null ? bubbleOffset.dy : 0) +
                            activeChartTop,

                        child: TweenAnimationBuilder<double>(
                          duration: widget.theme.rotationDuration,
                          curve: Curves.easeInOut, // match rotation
                          tween: Tween<double>(
                            end: currentTriangleDirection ==
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
                                          (selectedIndex! < widget.data.length
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
                                              direction: TriangleDirection.down,
                                            ),
                                            child: Container(
                                              width: 20,
                                              height: 10,
                                              color: widget.theme.dataLineColor,
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
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant InteractiveSpiderChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset title visibility tracking if labels list shrinks to empty.
    if (widget.labels.isEmpty) {
      _lastTitleVisible = false;
    }
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
