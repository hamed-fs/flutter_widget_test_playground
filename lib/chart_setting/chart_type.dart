part of 'chart_setting.dart';

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
