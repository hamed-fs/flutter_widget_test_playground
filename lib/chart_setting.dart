import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';

import 'package:flutter_widget_test_playground/enums.dart';

typedef OnSelectChartTypeCallback = void Function(ChartType);
typedef OnSelectChartIntervalCallback = void Function(ChartInterval);

/// Chart setting
class ChartSetting extends StatefulWidget {
  /// Initializes
  const ChartSetting({
    Key key,
    this.selectedChartType = ChartType.area,
    this.selectedChartInterval = ChartInterval.oneTick,
    this.onSelectChartType,
    this.onSelectChartInterval,
  }) : super(key: key);

  /// Selected chart type
  final ChartType selectedChartType;

  /// Selected chart interval
  final ChartInterval selectedChartInterval;

  /// On select chart type callback
  final OnSelectChartTypeCallback onSelectChartType;

  /// On select chart interval callback
  final OnSelectChartIntervalCallback onSelectChartInterval;

  @override
  _ChartSettingState createState() => _ChartSettingState();
}

class _ChartSettingState extends State<ChartSetting> {
  final ThemeProvider _themeProvider = ThemeProvider();

  ChartType _selectedChartType;
  ChartInterval _selectedChartInterval;

  final ScrollController _chartIntervalScrollController = ScrollController();
  final ScrollController _chartTypeScrollController = ScrollController();

  static const double _chartTypeItemHight = 80;
  static const double _chartTypeItemWidth = 160;

  static const double _chartIntervalItemHight = 48;
  static const double _chartIntervalItemWidth = 76;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _selectedChartType ??= widget.selectedChartType;
    _selectedChartInterval ??= widget.selectedChartInterval;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_ChartType.types.length > 2) {
        _moveToSelectedItem<_ChartType>(
          items: _ChartType.types,
          controller: _chartTypeScrollController,
          predicate: (_ChartType chartType) =>
              chartType.chartType == _selectedChartType,
          itemWidth: _chartTypeItemWidth,
        );
      }

      _moveToSelectedItem<_ChartInterval>(
        items: _ChartInterval.intervals,
        controller: _chartIntervalScrollController,
        predicate: (_ChartInterval chartType) =>
            chartType.interval == _selectedChartInterval,
        itemWidth: _chartIntervalItemWidth,
      );
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _buildList<_ChartType>(
            items: _ChartType.types,
            childBuilder: _buildChartTypeButton,
            scrollController: _chartTypeScrollController,
            listHight: _chartTypeItemHight,
            itemWidth: _chartTypeItemWidth,
          ),
          _buildList<_ChartInterval>(
            items: _ChartInterval.intervals,
            childBuilder: _buildChartIntervalButton,
            scrollController: _chartIntervalScrollController,
            listHight: _chartIntervalItemHight,
            itemWidth: _chartIntervalItemWidth,
          ),
        ],
      );

  Widget _buildList<T>({
    @required List<T> items,
    @required Widget Function(T item) childBuilder,
    @required ScrollController scrollController,
    @required double listHight,
    @required double itemWidth,
    double spaceBetweenItems = 8.0,
  }) =>
      Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: listHight,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return false;
            },
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              shrinkWrap: true,
              controller: scrollController,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(width: spaceBetweenItems),
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: itemWidth,
                height: listHight,
                child: childBuilder(items[index]),
              ),
            ),
          ),
        ),
      );

  Widget _buildChartTypeButton(
    _ChartType chartType,
  ) =>
      OutlineButton(
        // ignore: avoid_redundant_argument_values
        padding: const EdgeInsets.only(top: 0),
        child: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Column(
            children: <Widget>[
              Image.asset(
                chartType.imageAsset,
                height: 20,
              ),
              const SizedBox(height: 6),
              Text(
                chartType.title,
                style: _themeProvider.textStyle(
                  textStyle: TextStyles.body2,
                  color: _themeProvider.base01Color,
                ),
              ),
            ],
          ),
        ),
        borderSide: BorderSide(
          color: _selectedChartType == chartType.chartType
              ? _themeProvider.brandGreenishColor
              : _themeProvider.base06Color,
        ),
        highlightedBorderColor: _themeProvider.brandGreenishColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        onPressed: () {
          if (widget.onSelectChartType != null) {
            widget.onSelectChartType(chartType.chartType);
          }

          setState(() => _selectedChartType = chartType.chartType);
        },
      );

  Widget _buildChartIntervalButton(_ChartInterval chartInterval) =>
      OutlineButton(
        // ignore: avoid_redundant_argument_values
        padding: const EdgeInsets.only(top: 0),
        child: Text(
          chartInterval.title,
          style: _themeProvider.textStyle(
            textStyle: TextStyles.body2,
            color: _themeProvider.base01Color,
          ),
        ),
        borderSide: BorderSide(
          color: _selectedChartInterval == chartInterval.interval
              ? _themeProvider.brandGreenishColor
              : _themeProvider.base06Color,
        ),
        highlightedBorderColor: _themeProvider.brandGreenishColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        onPressed: () {
          if (widget.onSelectChartInterval != null) {
            widget.onSelectChartInterval(chartInterval.interval);
          }

          setState(() => _selectedChartInterval = chartInterval.interval);
        },
      );

  void _moveToSelectedItem<T>({
    @required List<T> items,
    @required ScrollController controller,
    @required bool Function(T) predicate,
    @required double itemWidth,
    double spaceBetweenItems = 8.0,
  }) =>
      controller.jumpTo(
        items.indexOf(items.firstWhere((T item) => predicate(item))) *
                (itemWidth + spaceBetweenItems) -
            spaceBetweenItems,
      );
}

class _ChartType {
  _ChartType({
    this.title,
    this.chartType,
    this.imageAsset,
  });

  final String title;
  final ChartType chartType;
  final String imageAsset;

  static const String assetPath = 'assets/images/chart_setting';

  static final List<_ChartType> types = <_ChartType>[
    _ChartType(
      chartType: ChartType.area,
      title: 'Area',
      imageAsset: '$assetPath/area_chart_icon.png',
    ),
    _ChartType(
      chartType: ChartType.candle,
      title: 'Candle',
      imageAsset: '$assetPath/candle_chart_icon.png',
    ),
  ];
}

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
