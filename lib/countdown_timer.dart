import 'dart:async';
import 'package:flutter/material.dart';

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
        setState(() {
          _difference = Duration(seconds: _difference.inSeconds - 1);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Text(
        _formatDuration(_difference),
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF6E6E6E),
          fontFamily: 'IBMPlexSans',
        ),
      );

  String _formatDuration(Duration duration) {
    final String twoDigitMinutes =
        _formatDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds =
        _formatDigits(duration.inSeconds.remainder(60));

    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  String _formatDigits(int number) => number >= 10 ? '$number' : '0$number';

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }
}
