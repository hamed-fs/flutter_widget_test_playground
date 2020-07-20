import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef OnSelectChartType = void Function(ChartType);
typedef OnSelectChartDuration = void Function(ChartDuration);

class ChartSetting extends StatefulWidget {
  final ChartType selectedChartType;
  final ChartDuration selectedChartDuration;

  final OnSelectChartType onSelectChartType;
  final OnSelectChartDuration onSelectChartDuration;

  ChartSetting({
    Key key,
    this.selectedChartType = ChartType.area,
    this.selectedChartDuration = ChartDuration.oneTick,
    this.onSelectChartType,
    this.onSelectChartDuration,
  }) : super(key: key);

  @override
  _ChartSettingState createState() => _ChartSettingState();
}

class _ChartSettingState extends State<ChartSetting> {
  ChartType _selectedChartType;
  ChartDuration _selectedChartDuration;

  final ScrollController _chartDurationScrollController = ScrollController();
  final ScrollController _chartTypeScrollController = ScrollController();

  final TextStyle _buttonTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'IBMPlexSans',
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_selectedChartType == null) {
      _selectedChartType = widget.selectedChartType;
    }

    if (_selectedChartDuration == null) {
      _selectedChartDuration = widget.selectedChartDuration;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (chartTypes.length > 2) {
        _moveToSelectedItem<ChartTypeInformation>(
          items: chartTypes,
          controller: _chartTypeScrollController,
          predicate: (ChartTypeInformation chartType) =>
              chartType.chartType == _selectedChartType,
          itemWidth: 160.0,
        );
      }

      _moveToSelectedItem<ChartDurationInformation>(
        items: chartDurations,
        controller: _chartDurationScrollController,
        predicate: (ChartDurationInformation chartType) =>
            chartType.chartDuration == _selectedChartDuration,
        itemWidth: 76.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _buildList<ChartTypeInformation>(
            items: chartTypes,
            childBuilder: _buildChartTypeButton,
            scrollController: _chartTypeScrollController,
            listHight: 80.0,
            itemWidth: 160.0,
          ),
          _buildList<ChartDurationInformation>(
            items: chartDurations,
            childBuilder: _buildChartDurationButton,
            scrollController: _chartDurationScrollController,
            listHight: 48.0,
            itemWidth: 76.0,
          ),
        ],
      );

  Widget _buildList<T>({
    @required List<T> items,
    @required Widget Function(T item) childBuilder,
    @required ScrollController scrollController,
    @required double listHight,
    @required double itemWidth,
    double listPadding = 16.0,
    double spaceBetweenItems = 6.0,
  }) =>
      Padding(
        padding: EdgeInsets.all(listPadding),
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

  Widget _buildChartTypeButton(ChartTypeInformation chartType) => OutlineButton(
        padding: const EdgeInsets.only(top: 0.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                chartType.imageAsset,
                height: 20.0,
              ),
              SizedBox(height: 6.0),
              Text(
                chartType.title,
                style: _buttonTextStyle,
              ),
            ],
          ),
        ),
        borderSide: BorderSide(
          color: _selectedChartType == chartType.chartType
              ? Color(0xFF85ACB0)
              : Color(0xFF323738),
        ),
        highlightedBorderColor: Color(0xFF85ACB0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: () {
          if (widget.onSelectChartType != null) {
            widget.onSelectChartType(chartType.chartType);
          }

          setState(() => _selectedChartType = chartType.chartType);
        },
      );

  Widget _buildChartDurationButton(ChartDurationInformation chartDuration) =>
      OutlineButton(
        padding: const EdgeInsets.only(top: 0.0),
        child: Text(
          chartDuration.title,
          style: _buttonTextStyle,
        ),
        borderSide: BorderSide(
          color: _selectedChartDuration == chartDuration.chartDuration
              ? Color(0xFF85ACB0)
              : Color(0xFF323738),
        ),
        highlightedBorderColor: Color(0xFF85ACB0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: () {
          if (widget.onSelectChartDuration != null) {
            widget.onSelectChartDuration(chartDuration.chartDuration);
          }

          setState(() => _selectedChartDuration = chartDuration.chartDuration);
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

enum ChartType {
  area,
  candle,
}

enum ChartDuration {
  oneTick,
  oneMin,
  twoMin,
  treeMin,
  fiveMin,
  tenMin,
  fifteenMin,
  thirtyMin,
  oneHour,
  twoHours,
  fourHours,
  eightHours,
  oneDay,
}

class ChartTypeInformation {
  final String title;
  final ChartType chartType;
  final String imageAsset;

  ChartTypeInformation({
    this.title,
    this.chartType,
    this.imageAsset,
  });
}

class ChartDurationInformation {
  final String title;
  final ChartDuration chartDuration;

  ChartDurationInformation({
    this.title,
    this.chartDuration,
  });
}

List<ChartTypeInformation> chartTypes = <ChartTypeInformation>[
  ChartTypeInformation(
    chartType: ChartType.area,
    title: 'Area',
    imageAsset: 'assets/icons/area_chart_icon.png',
  ),
  ChartTypeInformation(
    chartType: ChartType.candle,
    title: 'Candle',
    imageAsset: 'assets/icons/candle_chart_icon.png',
  ),
];

List<ChartDurationInformation> chartDurations = <ChartDurationInformation>[
  ChartDurationInformation(
    chartDuration: ChartDuration.oneTick,
    title: '1 tick',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.oneMin,
    title: '1 min',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.twoMin,
    title: '2 min',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.treeMin,
    title: '3 min',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.fiveMin,
    title: '5 min',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.tenMin,
    title: '10 min',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.fifteenMin,
    title: '15 min',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.thirtyMin,
    title: '30 min',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.oneHour,
    title: '1 hour',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.twoHours,
    title: '2 hours',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.fourHours,
    title: '4 hours',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.eightHours,
    title: '8 hours',
  ),
  ChartDurationInformation(
    chartDuration: ChartDuration.oneDay,
    title: '1 day',
  ),
];
