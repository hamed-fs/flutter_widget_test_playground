import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';
import 'package:flutter_widget_test_playground/assets.dart';
import 'package:flutter_widget_test_playground/enums.dart';

part 'chart_interval_button.dart';
part 'chart_interval_information.dart';
part 'chart_setting_list.dart';
part 'chart_type_button.dart';
part 'chart_type_information.dart';

typedef ChartTypeHandler = void Function(ChartType);
typedef ChartIntervalHandler = void Function(ChartInterval);

/// Chart setting
///
/// This widget show available [ChartType]s and [ChartInterval]s
/// [selectedChartType] and [selectedChartInterval] is for select default values
///
/// You can use [onSelectChartType] and [onSelectChartInterval] handlers
/// to receive user selections
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
  final ChartTypeHandler onSelectChartType;

  /// On select chart interval callback
  final ChartIntervalHandler onSelectChartInterval;

  @override
  _ChartSettingState createState() => _ChartSettingState();
}

class _ChartSettingState extends State<ChartSetting> {
  ChartType _selectedChartType;
  ChartInterval _selectedChartInterval;

  final List<_ChartTypeInformation> _chartTypes = _ChartTypeInformation.types;
  final List<_ChartIntervalInformation> _chartIntervals =
      _ChartIntervalInformation.intervals;

  static const double _chartTypeItemWidth = 160;
  static const double _chartTypeItemHeight = 80;

  static const double _chartIntervalItemWidth = 76;
  static const double _chartIntervalItemHeight = 48;

  static const double _spaceBetweenItems = 8;

  final ScrollController _chartTypeScrollController = ScrollController();
  final ScrollController _chartIntervalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _selectedChartType = widget.selectedChartType;
    _selectedChartInterval = widget.selectedChartInterval;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _moveToSelectedItem();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _ChartSettingList<_ChartTypeInformation, ChartType, ChartTypeHandler>(
            itemBuilder: (
              _ChartTypeInformation item,
              ChartType type,
              ChartTypeHandler onSelect,
            ) =>
                _ChartTypeButton(
              information: item,
              type: type,
              onTap: onSelect,
            ),
            items: _chartTypes,
            scrollController: _chartTypeScrollController,
            itemWidth: _chartTypeItemWidth,
            itemHeight: _chartTypeItemHeight,
            spaceBetweenItems: _spaceBetweenItems,
            selectedType: _selectedChartType,
            onSelect: (ChartType type) {
              widget.onSelectChartType?.call(type);

              setState(() => _selectedChartType = type);
            },
          ),
          _ChartSettingList<_ChartIntervalInformation, ChartInterval,
              ChartIntervalHandler>(
            itemBuilder: (
              _ChartIntervalInformation item,
              ChartInterval interval,
              ChartIntervalHandler onSelect,
            ) =>
                _ChartIntervalButton(
              information: item,
              interval: interval,
              onTap: onSelect,
            ),
            items: _chartIntervals,
            scrollController: _chartIntervalScrollController,
            itemWidth: _chartIntervalItemWidth,
            itemHeight: _chartIntervalItemHeight,
            spaceBetweenItems: _spaceBetweenItems,
            selectedType: _selectedChartInterval,
            onSelect: (ChartInterval interval) {
              widget.onSelectChartInterval?.call(interval);

              setState(() => _selectedChartInterval = interval);
            },
          ),
        ],
      );

  void _moveToSelectedItem() =>
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_chartTypes.length > 2) {
          _ChartSettingList.moveToSelectedItem<_ChartTypeInformation>(
            items: _chartTypes,
            scrollController: _chartTypeScrollController,
            itemWidth: _chartTypeItemWidth,
            spaceBetweenItems: _spaceBetweenItems,
            predicate: (_ChartTypeInformation chartType) =>
                chartType.chartType == _selectedChartType,
          );
        }

        _ChartSettingList.moveToSelectedItem<_ChartIntervalInformation>(
          items: _chartIntervals,
          scrollController: _chartIntervalScrollController,
          itemWidth: _chartIntervalItemWidth,
          spaceBetweenItems: _spaceBetweenItems,
          predicate: (_ChartIntervalInformation chartType) =>
              chartType.interval == _selectedChartInterval,
        );
      });
}
