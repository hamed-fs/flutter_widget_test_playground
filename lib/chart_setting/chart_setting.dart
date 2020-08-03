import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';

import 'package:flutter_widget_test_playground/enums.dart';

part 'chart_interval_button.dart';
part 'chart_interval_list.dart';
part 'chart_interval.dart';
part 'chart_type_button.dart';
part 'chart_type_list.dart';
part 'chart_type.dart';

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
  ChartType _selectedChartType;
  ChartInterval _selectedChartInterval;

  final List<_ChartType> _chartTypes = _ChartType.types;
  final List<_ChartInterval> _chartIntervals = _ChartInterval.intervals;

  final ScrollController _chartTypeScrollController = ScrollController();
  final ScrollController _chartIntervalScrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _selectedChartType ??= widget.selectedChartType;
    _selectedChartInterval ??= widget.selectedChartInterval;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _ChartTypeList.moveToSelectedItem(
        items: _chartTypes,
        scrollController: _chartTypeScrollController,
        predicate: (_ChartType chartType) =>
            chartType.chartType == _selectedChartType,
      );

      _ChartIntervalList.moveToSelectedItem(
        items: _chartIntervals,
        scrollController: _chartIntervalScrollController,
        predicate: (_ChartInterval chartType) =>
            chartType.interval == _selectedChartInterval,
      );
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _ChartTypeList(
            items: _chartTypes,
            selectedChartType: _selectedChartType,
            scrollController: _chartTypeScrollController,
            onSelectChartType: (ChartType type) {
              widget.onSelectChartType?.call(type);

              setState(() => _selectedChartType = type);
            },
          ),
          _ChartIntervalList(
            items: _chartIntervals,
            selectedChartInterval: _selectedChartInterval,
            scrollController: _chartIntervalScrollController,
            onSelectChartInterval: (ChartInterval interval) {
              widget.onSelectChartInterval?.call(interval);

              setState(() => _selectedChartInterval = interval);
            },
          ),
        ],
      );
}
