part of 'helpers.dart';

/// Formats a duration to time
String formatDuration({
  @required Duration duration,
  bool showTimeLabels = false,
  bool showHour = true,
  bool showSecond = true,
}) {
  final NumberFormat formatter = NumberFormat('00');
  final int hours = duration.inHours.remainder(60);
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);

  // TODO(hamed): change strings according to ui design
  final String hoursFormatted = showHour
      ? showTimeLabels
          ? Intl.plural(hours,
              one: '${formatter.format(hours)} hr',
              other: '${formatter.format(hours)} hr')
          : formatter.format(hours)
      : '';
  final String minutesFormatted = showTimeLabels
      ? Intl.plural(minutes,
          one: '${formatter.format(minutes)} min',
          other: '${formatter.format(minutes)} min')
      : formatter.format(minutes);
  final String secondsFormatted = showSecond
      ? showTimeLabels
          ? Intl.plural(seconds,
              one: '${formatter.format(seconds)} sec',
              other: '${formatter.format(seconds)} sec')
          : formatter.format(seconds)
      : '';

  final String result =
      '${showHour ? '$hoursFormatted:' : ''}$minutesFormatted${showSecond ? ':$secondsFormatted' : ''}'
          .replaceAll(':', showTimeLabels ? ' ' : ':')
          .trim();

  return result;
}
