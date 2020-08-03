import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_widget_test_playground/countdown_timer.dart';

void main() {
  group('Countdown Timer =>', () {
    testWidgets(
      'should call `onCountdownFinished()` callback when counter reaches to zero.',
      (WidgetTester tester) async {
        final DateTime startTime = DateTime.now();
        final DateTime endTime = DateTime.now().add(const Duration(seconds: 1));

        bool isCountdownFinished = false;

        final CountdownTimer timer = CountdownTimer(
          startTime: startTime,
          endTime: endTime,
          widgetBuilder: (String timer) => Text(timer),
          onCountdownFinished: () => isCountdownFinished = true,
        );

        await tester.pumpWidget(_TestApp(timer));
        await tester.pump(const Duration(seconds: 2));
        expect(isCountdownFinished, isTrue);
      },
    );
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp(this.timer);

  final CountdownTimer timer;

  @override
  Widget build(BuildContext context) => MaterialApp(home: timer);
}
