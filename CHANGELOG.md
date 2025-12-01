## 1.0.6

- **New Features**

  - Added `TitleLabelBehavior` to control title show/hide behavior on tap (always vs toggle).
  - Added title slide configuration: `titleSlideSpace`, `enableTitleSlide`, `titleSlideDuration`, and `titleSlideCurve` for smoother chart/title transitions.
  - Added `labelRadiusFactor` to `SpiderChartThemeData` to push/pull labels away from the chart (useful when points sit on the outline).

- **Improvements**

  - Chart now starts with title/bubble hidden until a tap occurs, matching the new toggle behavior.
  - Title animation plays only on the first show; label text swaps cleanly without overlap on subsequent label changes.
  - Chart positioning smoothened: sits at top when hidden, slides down only when the title first appears.

- **Bug Fixes**

  - Fixed initial title overlap/ghosting when showing the title for the first time.
  - Bubble anchor now respects `labelRadiusFactor` when anchoring to labels.

- **Maintenance**
  - Synced InteractiveSpiderChart sizing/offsets with parent constraints so chart and bubbles align correctly with labels/points in host apps.

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
