import 'package:flutter/material.dart';

class SpiderChartThemeData {
  /// Color of the spider web grid lines
  final Color gridLineColor;

  /// Color of the dashed inner circles
  final Color gridDashedLineColor;

  /// Color of the axis lines radiating from center
  final Color spokeLineColor;

  /// Color of the data polygon outline
  final Color dataLineColor;

  /// Color of the data polygon fill (if gradient is disabled)
  final Color dataFillColor;

  /// Whether to use a gradient fill for the data polygon
  final bool useGradient;

  /// Gradient colors for the data polygon (if useGradient is true)
  final List<Color>? gradientColors;

  /// Style for the labels around the chart
  final TextStyle labelStyle;

  /// Style for the selected label (when highlighted)
  final TextStyle selectedLabelStyle;

  /// Whether to show/highlight the selected label
  final bool showSelectedLabel;

  /// Whether to show the selected label as a title above the chart
  final bool showTitleSelectedLabel;

  /// Style for the selected label title
  final TextStyle titleSelectedLabelStyle;

  /// Top offset for the selected label title
  final double titleSelectedLabelTopOffset;

  /// Top offset for the chart itself
  final double chartTopOffset;

  /// Distance from the chart outer ring to the labels
  final double labelOffsetFromChart;

  /// Vertical offset for the score bubble
  final double bubbleOffset;

  /// Width of the data line
  final double strokeWidth;

  /// Size of the dots at data points
  final double pointSize;

  /// Color of the dots at data points
  final Color pointColor;

  /// Whether to rotate the chart so the selected label is at the top
  final bool rotateToTop;

  /// Duration of the rotation animation
  final Duration rotationDuration;

  const SpiderChartThemeData({
    this.gridLineColor = const Color(
      0x4D9E9E9E,
    ), // Colors.grey.withOpacity(0.3)
    this.gridDashedLineColor = const Color(
      0x337B4DFF,
    ), // Colors.deepPurple.withOpacity(0.2)
    this.spokeLineColor = const Color(
      0x1A9E9E9E,
    ), // Colors.grey.withOpacity(0.1)
    this.dataLineColor = const Color(0xFF7B4DFF), // Colors.deepPurple
    this.dataFillColor = const Color(
      0x267B4DFF,
    ), // Colors.deepPurple.withOpacity(0.15)
    this.useGradient = false,
    this.gradientColors,
    this.labelStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    this.selectedLabelStyle = const TextStyle(
      color: Color(0xFF7B4DFF),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    this.showSelectedLabel = true,
    this.showTitleSelectedLabel = false,
    this.titleSelectedLabelStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.titleSelectedLabelTopOffset = 0.0,
    this.chartTopOffset = 0.0,
    this.labelOffsetFromChart = 10.0,
    this.bubbleOffset = 10.0,
    this.strokeWidth = 3.0,
    this.pointSize = 4.0,
    this.pointColor = const Color(0xFF7B4DFF),
    this.rotateToTop = true,
    this.rotationDuration = const Duration(milliseconds: 500),
  });

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  SpiderChartThemeData copyWith({
    Color? gridLineColor,
    Color? gridDashedLineColor,
    Color? spokeLineColor,
    Color? dataLineColor,
    Color? dataFillColor,
    bool? useGradient,
    List<Color>? gradientColors,
    TextStyle? labelStyle,
    TextStyle? selectedLabelStyle,
    bool? showSelectedLabel,
    bool? showTitleSelectedLabel,
    TextStyle? titleSelectedLabelStyle,
    double? titleSelectedLabelTopOffset,
    double? chartTopOffset,
    double? labelOffsetFromChart,
    double? bubbleOffset,
    double? strokeWidth,
    double? pointSize,
    Color? pointColor,
    bool? rotateToTop,
    Duration? rotationDuration,
  }) {
    return SpiderChartThemeData(
      gridLineColor: gridLineColor ?? this.gridLineColor,
      gridDashedLineColor: gridDashedLineColor ?? this.gridDashedLineColor,
      spokeLineColor: spokeLineColor ?? this.spokeLineColor,
      dataLineColor: dataLineColor ?? this.dataLineColor,
      dataFillColor: dataFillColor ?? this.dataFillColor,
      useGradient: useGradient ?? this.useGradient,
      gradientColors: gradientColors ?? this.gradientColors,
      labelStyle: labelStyle ?? this.labelStyle,
      selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
      showSelectedLabel: showSelectedLabel ?? this.showSelectedLabel,
      showTitleSelectedLabel:
          showTitleSelectedLabel ?? this.showTitleSelectedLabel,
      titleSelectedLabelStyle:
          titleSelectedLabelStyle ?? this.titleSelectedLabelStyle,
      titleSelectedLabelTopOffset:
          titleSelectedLabelTopOffset ?? this.titleSelectedLabelTopOffset,
      chartTopOffset: chartTopOffset ?? this.chartTopOffset,
      labelOffsetFromChart: labelOffsetFromChart ?? this.labelOffsetFromChart,
      bubbleOffset: bubbleOffset ?? this.bubbleOffset,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      pointSize: pointSize ?? this.pointSize,
      pointColor: pointColor ?? this.pointColor,
      rotateToTop: rotateToTop ?? this.rotateToTop,
      rotationDuration: rotationDuration ?? this.rotationDuration,
    );
  }
}
