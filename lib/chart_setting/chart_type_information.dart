part of 'chart_setting.dart';

class _ChartTypeInformation {
  _ChartTypeInformation({
    this.title,
    this.chartType,
    this.imageAsset,
    this.semanticsLabel,
  });

  final String title;
  final ChartType chartType;
  final String imageAsset;
  final String semanticsLabel;

  static final List<_ChartTypeInformation> types = <_ChartTypeInformation>[
    _ChartTypeInformation(
      chartType: ChartType.area,
      title: 'Area',
      imageAsset: areaChartIcon,
      semanticsLabel: 'Area Chart Icon',
    ),
    _ChartTypeInformation(
      chartType: ChartType.candle,
      title: 'Candle',
      imageAsset: candleChartIcon,
      semanticsLabel: 'Candle Chart Icon',
    ),
  ];
}
