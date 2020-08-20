import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_widget_test_playground/helpers/helpers.dart';

/// Countdown timer widget
class CountdownTimer extends StatefulWidget {
  /// Countdown timer is a widget to show animated time
  ///
  /// [startTime] and [endTime] will be used for duration calculation.
  /// [widgetBuilder] indicates widget that shows result.
  /// If you want to show `hour` part set [showHour] to true.
  /// [showTimePartLabels] determine you want to show time separator or time part labels.
  /// [onCountdownFinished] will be called when countdown reaches to zero.
  const CountdownTimer({
    @required this.startTime,
    @required this.endTime,
    @required this.widgetBuilder,
    Key key,
    this.showHour = false,
    this.showSecond = true,
    this.showTimePartLabels = false,
    this.onCountdownFinished,
  }) : super(key: key);

  /// Start time
  final DateTime startTime;

  /// End time
  final DateTime endTime;

  /// Shows hour
  ///
  /// Default value is `false`
  final bool showHour;

  /// Shows second
  ///
  /// Default value is `true`
  final bool showSecond;

  /// Shows time labels
  ///
  /// Default value is `false`
  final bool showTimePartLabels;

  /// Timer container widget builder
  final Widget Function(String) widgetBuilder;

  /// On countdown finished callback
  final VoidCallback onCountdownFinished;

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer _timer;
  Duration _difference;

  @override
  void initState() {
    DateTime endTime = widget.endTime;

    if (widget.endTime.compareTo(widget.startTime) == -1) {
      endTime = widget.startTime;
    }

    _difference = endTime.difference(widget.startTime);

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_difference.inSeconds <= 0) {
        _timer.cancel();

        if (widget.onCountdownFinished != null) {
          widget.onCountdownFinished();
        }
      } else {
        setState(
          () => _difference = Duration(seconds: _difference.inSeconds - 1),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      widget.widgetBuilder(_formatDuration(_difference));

  String _formatDuration(Duration duration) => formatDuration(
        duration: duration,
        showHour: widget.showHour,
        showSecond: widget.showSecond,
        showTimeLabels: widget.showTimePartLabels,
      );

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }
}
