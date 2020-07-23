import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_widget_test_playground/countdown_timer.dart';

void main() {
  testWidgets(
    'should call `onCountdownFinished()` callback when counter reaches to zero.',
    (WidgetTester tester) async {
      bool isOnCountdownFinishedCalled = false;

      final CountdownTimer timer = CountdownTimer(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(seconds: 1)),
        onCountdownFinished: () => isOnCountdownFinishedCalled = true,
      );

      await tester.pumpWidget(TestApp(timer));
      await tester.pump(const Duration(seconds: 2));
      expect(isOnCountdownFinishedCalled, isTrue);
    },
  );
}

class TestApp extends StatefulWidget {
  const TestApp(this.timer);

  final CountdownTimer timer;

  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: widget.timer,
      );
}
