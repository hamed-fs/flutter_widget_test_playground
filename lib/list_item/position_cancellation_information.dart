part of 'position_item.dart';

class _PositionCancellationInformation extends StatelessWidget {
  const _PositionCancellationInformation({
    @required this.isOpen,
    @required this.cancellationInfo,
    Key key,
  }) : super(key: key);

  final bool isOpen;
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
        isOpen
            ? CountdownTimer(
                // TODO(hamed): add server time instead of local machine time
                startTime: DateTime.now(),
                endTime: cancellationInfo.dateExpiry,
                showHour: true,
                showTimePartLabels: true,
                showSecond: false,
                widgetBuilder: (String timer) => Text(
                  timer,
                  style: _themeProvider.textStyle(
                    textStyle: TextStyles.caption,
                    color: _themeProvider.base04Color,
                  ),
                ),
              )
            : Text(
                _getElapsedTime(),
                style: _themeProvider.textStyle(
                  textStyle: TextStyles.caption,
                  color: _themeProvider.base04Color,
                ),
              ),
      ],
    );
  }

  // TODO(hamed): add implementation for closed positions
  String _getElapsedTime() => formatDuration(
        duration: const Duration(minutes: 5),
        showHour: false,
        showSecond: false,
        showTimeLabels: true,
      );
}
