part of 'position_item.dart';

class _PositionCancellationInformation extends StatelessWidget {
  const _PositionCancellationInformation({
    @required this.cancellationInfo,
    Key key,
  }) : super(key: key);

  final CancellationInfoModel cancellationInfo;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = ThemeProvider();

    return Row(
      children: <Widget>[
        SvgPicture.asset(
          dealCancellationIcon,
          height: 24,
          semanticsLabel: 'Deal Cancellation Indicator',
        ),
        CountdownTimer(
          // TODO(hamed): add server time instead of local machine time
          startTime: DateTime.now(),
          endTime: cancellationInfo.dateExpiry,
          widgetBuilder: (String timer) => Text(
            timer,
            style: _themeProvider.textStyle(
              textStyle: TextStyles.caption,
              color: _themeProvider.base04Color,
            ),
          ),
        ),
      ],
    );
  }
}
