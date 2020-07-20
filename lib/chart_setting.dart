import 'package:flutter/material.dart';

typedef OnSelectChartType = void Function(ChartType);
typedef OnSelectChartDuration = void Function(ChartDuration);

class ChartSetting extends StatefulWidget {
  ChartSetting({Key key}) : super(key: key);

  @override
  _ChartSettingState createState() => _ChartSettingState();
}

class _ChartSettingState extends State<ChartSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(),
    );
  }
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
