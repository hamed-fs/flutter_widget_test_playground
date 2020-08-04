part of 'chart_setting.dart';

class _ChartIntervalButton extends StatelessWidget {
  _ChartIntervalButton({
    @required this.information,
    @required this.interval,
    Key key,
    this.onSelect,
  }) : super(key: key);

  final _ChartIntervalInformation information;
  final ChartInterval interval;

  final OnSelectChartIntervalCallback onSelect;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => OutlineButton(
        // ignore: avoid_redundant_argument_values
        padding: const EdgeInsets.only(top: 0),
        child: Text(
          information.title,
          style: _themeProvider.textStyle(
            textStyle: TextStyles.body2,
            color: _themeProvider.base01Color,
          ),
        ),
        borderSide: BorderSide(
          color: information.interval == interval
              ? _themeProvider.brandGreenishColor
              : _themeProvider.base06Color,
        ),
        highlightedBorderColor: _themeProvider.brandGreenishColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        onPressed: () => onSelect?.call(information.interval),
      );
}
