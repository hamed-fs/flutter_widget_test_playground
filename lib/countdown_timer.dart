import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Countdown timer
class CountdownTimer extends StatefulWidget {
  /// Initializes
  const CountdownTimer({
    Key key,
    this.startTime,
    this.endTime,
    this.onCountdownFinished,
  }) : super(key: key);

  /// Start time
  final DateTime startTime;

  /// End time
  final DateTime endTime;

  /// On countdown finished callback
  final VoidCallback onCountdownFinished;

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer _timer;
  Duration _difference;

  final TextStyle timerStyle = const TextStyle(
    fontSize: 12,
    color: Color(0xFF6E6E6E),
    fontFamily: 'IBMPlexSans',
  );

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
      Text(_formatDuration(_difference), style: timerStyle);

  String _formatDuration(Duration duration) {
    final NumberFormat formatter = NumberFormat('00');
    final String minutes = formatter.format(duration.inMinutes.remainder(60));
    final String seconds = formatter.format(duration.inSeconds.remainder(60));

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }
}
