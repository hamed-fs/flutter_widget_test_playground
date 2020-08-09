part of 'chart_setting.dart';

class _ChartTypeButton extends StatelessWidget {
  _ChartTypeButton({
    @required this.information,
    @required this.type,
    Key key,
    this.onTap,
  }) : super(key: key);

  final _ChartTypeInformation information;
  final ChartType type;

  final ChartTypeHandler onTap;

  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) => OutlineButton(
        // ignore: avoid_redundant_argument_values
        padding: const EdgeInsets.only(top: 0),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: <Widget>[
              Image.asset(
                information.imageAsset,
                height: 24,
              ),
              const SizedBox(height: 4),
              Text(
                information.title,
                style: _themeProvider.textStyle(
                  textStyle: TextStyles.body2,
                  color: _themeProvider.base01Color,
                ),
              ),
            ],
          ),
        ),
        borderSide: BorderSide(
          color: information.chartType == type
              ? _themeProvider.brandGreenishColor
              : _themeProvider.base06Color,
        ),
        highlightedBorderColor: _themeProvider.brandGreenishColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        onPressed: () => onTap.call(information.chartType),
      );
}
