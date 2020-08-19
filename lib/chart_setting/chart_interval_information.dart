part of 'chart_setting.dart';

class _ChartIntervalInformation {
  _ChartIntervalInformation({
    this.title,
    this.interval,
  });

  final String title;
  final ChartInterval interval;

  static final List<_ChartIntervalInformation> intervals =
      <_ChartIntervalInformation>[
    _ChartIntervalInformation(
      interval: ChartInterval.oneTick,
      title: '1 tick',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.oneMinute,
      title: '1 min',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.twoMinutes,
      title: '2 mins',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.treeMinutes,
      title: '3 mins',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.fiveMinutes,
      title: '5 mins',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.tenMinutes,
      title: '10 mins',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.fifteenMinutes,
      title: '15 mins',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.thirtyMinutes,
      title: '30 mins',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.oneHour,
      title: '1 hour',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.twoHours,
      title: '2 hours',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.fourHours,
      title: '4 hours',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.eightHours,
      title: '8 hours',
    ),
    _ChartIntervalInformation(
      interval: ChartInterval.oneDay,
      title: '1 day',
    ),
  ];
}
