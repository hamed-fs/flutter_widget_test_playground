part of 'chart_setting.dart';

class _ChartInterval {
  _ChartInterval({
    this.title,
    this.interval,
  });

  final String title;
  final ChartInterval interval;

  static final List<_ChartInterval> intervals = <_ChartInterval>[
    _ChartInterval(
      interval: ChartInterval.oneTick,
      title: '1 tick',
    ),
    _ChartInterval(
      interval: ChartInterval.oneMinute,
      title: '1 min',
    ),
    _ChartInterval(
      interval: ChartInterval.twoMinutes,
      title: '2 min',
    ),
    _ChartInterval(
      interval: ChartInterval.treeMinutes,
      title: '3 min',
    ),
    _ChartInterval(
      interval: ChartInterval.fiveMinutes,
      title: '5 min',
    ),
    _ChartInterval(
      interval: ChartInterval.tenMinutes,
      title: '10 min',
    ),
    _ChartInterval(
      interval: ChartInterval.fifteenMinutes,
      title: '15 min',
    ),
    _ChartInterval(
      interval: ChartInterval.thirtyMinutes,
      title: '30 min',
    ),
    _ChartInterval(
      interval: ChartInterval.oneHour,
      title: '1 hour',
    ),
    _ChartInterval(
      interval: ChartInterval.twoHours,
      title: '2 hours',
    ),
    _ChartInterval(
      interval: ChartInterval.fourHours,
      title: '4 hours',
    ),
    _ChartInterval(
      interval: ChartInterval.eightHours,
      title: '8 hours',
    ),
    _ChartInterval(
      interval: ChartInterval.oneDay,
      title: '1 day',
    ),
  ];
}
