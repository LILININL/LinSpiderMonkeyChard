# LinSpiderMonkeyChart

A Flutter widget library for rendering interactive spider/radar charts.

## Features

- **Spider Chart**: Customizable radar chart with support for multiple datasets.
- **Interactive**: Supports touch interactions, rotation, and selection.
- **Customizable**: extensive theming options for colors, fonts, and styles.
- **Widgets**: Includes pre-built cards and list items for displaying charts.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  lin_spider_monkey_chart:
    path: /path/to/lin_spider_monkey_chart
```

## Usage

```dart
import 'package:lin_spider_monkey_chart/lin_spider_monkey_chart.dart';

SpiderChart(
  labels: ['A', 'B', 'C', 'D', 'E'],
  data: [80, 70, 90, 60, 85],
  maxValue: 100,
  theme: SpiderChartThemeData(
    dataLineColor: Colors.blue,
    dataFillColor: Colors.blue.withValues(alpha: 0.2),
  ),
)
```
