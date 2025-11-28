## 1.0.3

- **New Features**:

  - Added support for Spline (curved) charts. Enable it using `useSpline: true` in `SpiderChartThemeData`.
  - Added `titleSelectedLabelTopOffset` to `SpiderChartThemeData` for fine-tuning the selected label title position.

- **Improvements**:

  - Increased default chart radius factor to 0.85 for better space utilization.
  - Improved dynamic positioning of the selected label title to keep it closer to the chart.
  - Enhanced null safety support for data lists (`List<double?>`).

- **Bug Fixes**:
  - Fixed `RangeError` crashes when tapping on the chart with empty or mismatched data/labels.
  - Fixed layout issues where the title could disappear off-screen.

## 1.0.2

- Initial release of the library.

* Added `SpiderChart` widget for rendering radar charts.
* Added `InteractiveSpiderChart` for interactive features.
* Added `SpiderChartThemeData` for customization.
