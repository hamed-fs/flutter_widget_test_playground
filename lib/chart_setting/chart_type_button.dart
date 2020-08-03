part of 'chart_setting.dart';

class _ChartTypeButton extends StatelessWidget {
  _ChartTypeButton({
    @required this.chartType,
    @required this.isSelected,
    Key key,
    this.onSelect,
  }) : super(key: key);

  final _ChartType chartType;
  final bool isSelected;

  final OnSelectChartTypeCallback onSelect;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => OutlineButton(
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
          color: isSelected
              ? _themeProvider.brandGreenishColor
              : _themeProvider.base06Color,
        ),
        highlightedBorderColor: _themeProvider.brandGreenishColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        onPressed: () => onSelect.call(chartType.chartType),
      );
}
