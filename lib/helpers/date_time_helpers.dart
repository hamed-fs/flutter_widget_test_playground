part of 'helpers.dart';

/// Formats a duration to time
String formatDuration({
  @required Duration duration,
  bool showTimePartLabels = false,
  bool showHour = true,
  bool showSecond = true,
}) {
  final NumberFormat formatter = NumberFormat('00');
  final int hours = duration.inHours.remainder(60);
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);

  // TODO(hamed): change strings according to ui design
  final String hoursFormatted = showHour
      ? showTimePartLabels
          ? '${_getTimePartLabel(timePart: hours, singularLabel: 'hr', pluralLabel: 'hr', formatter: formatter)} '
          : '${formatter.format(hours)}:'
      : '';
  final String minutesFormatted = showTimePartLabels
      ? _getTimePartLabel(
          timePart: minutes,
          singularLabel: 'min',
          pluralLabel: 'min',
          formatter: formatter,
        )
      : formatter.format(minutes);
  final String secondsFormatted = showSecond
      ? showTimePartLabels
          ? ' ${_getTimePartLabel(timePart: seconds, singularLabel: 'sec', pluralLabel: 'sec', formatter: formatter)}'
          : ':${formatter.format(seconds)}'
      : '';

  return '$hoursFormatted$minutesFormatted$secondsFormatted'.trim();
}

String _getTimePartLabel({
  int timePart,
  String singularLabel,
  String pluralLabel,
  NumberFormat formatter,
}) =>
    Intl.plural(
      timePart,
      one: '${formatter.format(timePart)} $singularLabel',
      other: '${formatter.format(timePart)} $pluralLabel',
    );
