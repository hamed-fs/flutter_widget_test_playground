import 'enums.dart';

/// Extension methods for [ChartInterval] enum
extension ChartIntervalExtension on ChartInterval {
  /// Converts [ChartInterval] values to milliseconds
  int toMilliseconds() {
    const int oneSecond = 1000;
    const int oneMinute = 60 * oneSecond;
    const int oneHour = 60 * oneMinute;
    const int oneDay = 24 * oneHour;

    switch (this) {
      case ChartInterval.oneTick:
        return oneSecond;
      case ChartInterval.oneMinute:
        return oneMinute;
      case ChartInterval.twoMinutes:
        return 2 * oneMinute;
      case ChartInterval.treeMinutes:
        return 3 * oneMinute;
      case ChartInterval.fiveMinutes:
        return 5 * oneMinute;
      case ChartInterval.tenMinutes:
        return 10 * oneMinute;
      case ChartInterval.fifteenMinutes:
        return 15 * oneMinute;
      case ChartInterval.thirtyMinutes:
        return 30 * oneMinute;
      case ChartInterval.oneHour:
        return oneHour;
      case ChartInterval.twoHours:
        return 2 * oneHour;
      case ChartInterval.fourHours:
        return 4 * oneHour;
      case ChartInterval.eightHours:
        return 8 * oneHour;
      case ChartInterval.oneDay:
        return oneDay;

      default:
        return 0;
    }
  }
}
