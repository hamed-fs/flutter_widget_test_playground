import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    if (_selectedChartType == null) {
      _selectedChartType = widget.selectedChartType;
    }

    if (_selectedChartDuration == null) {
      _selectedChartDuration = widget.selectedChartDuration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildChartTypeList(),
        _buildChartDurationList(),
      ],
    );
  }

  Widget _buildChartTypeList() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 80.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: chartTypes.length,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(width: 8.0),
            itemBuilder: (BuildContext context, int index) => SizedBox(
              width: 160.0,
              height: 80.0,
              child: OutlineButton(
                padding: const EdgeInsets.only(top: 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        chartTypes[index].imageAsset,
                        height: 20.0,
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        chartTypes[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'IBMPlexSans',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                borderSide: BorderSide(
                  color: _selectedChartType == chartTypes[index].chartType
                      ? Color(0xFF85ACB0)
                      : Color(0xFF323738),
                  width: 1.0,
                ),
                highlightedBorderColor: Color(0xFF85ACB0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                onPressed: () {
                  if (widget.onSelectChartType != null) {
                    widget.onSelectChartType(chartTypes[index].chartType);
                  }

                  _selectedChartType = chartTypes[index].chartType;

                  setState(() {});
                },
              ),
            ),
          ),
        ),
      );

  Widget _buildChartDurationList() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 48.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: chartDurations.length,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(width: 8.0),
            itemBuilder: (BuildContext context, int index) => SizedBox(
              width: 76.0,
              height: 48.0,
              child: OutlineButton(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  chartDurations[index].title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'IBMPlexSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                borderSide: BorderSide(
                  color: _selectedChartDuration ==
                          chartDurations[index].chartDuration
                      ? Color(0xFF85ACB0)
                      : Color(0xFF323738),
                  width: 1.0,
                ),
                highlightedBorderColor: Color(0xFF85ACB0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                onPressed: () {
                  if (widget.onSelectChartDuration != null) {
                    widget.onSelectChartDuration(
                      chartDurations[index].chartDuration,
                    );
                  }

                  _selectedChartDuration = chartDurations[index].chartDuration;

                  setState(() {});
                },
              ),
            ),
          ),
        ),
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
