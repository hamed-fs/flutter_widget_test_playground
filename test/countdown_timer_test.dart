// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_widget_test_playground/countdown_timer.dart';

void main() {
  group('Countdown Timer =>', () {
    testWidgets(
      'should show just minute part.',
      (WidgetTester tester) async {
        final DateTime time = DateTime.now();

        final CountdownTimer timer = CountdownTimer(
          startTime: time,
          endTime: time,
          widgetBuilder: (String timer) => Text(timer),
          showHour: false,
          showSecond: false,
          showTimePartLabels: false,
        );

        await tester.pumpWidget(_TestApp(timer));

        expect(find.text('00'), findsOneWidget);
      },
    );

    testWidgets(
      'should show hour and minute part.',
      (WidgetTester tester) async {
        final DateTime time = DateTime.now();

        final CountdownTimer timer = CountdownTimer(
          startTime: time,
          endTime: time,
          widgetBuilder: (String timer) => Text(timer),
          showHour: true,
          showSecond: false,
          showTimePartLabels: false,
        );

        await tester.pumpWidget(_TestApp(timer));

        expect(find.text('00:00'), findsOneWidget);
      },
    );

    testWidgets(
      'should show hour, minute and second part.',
      (WidgetTester tester) async {
        final DateTime time = DateTime.now();

        final CountdownTimer timer = CountdownTimer(
          startTime: time,
          endTime: time,
          widgetBuilder: (String timer) => Text(timer),
          showHour: true,
          showSecond: true,
          showTimePartLabels: false,
        );

        await tester.pumpWidget(_TestApp(timer));

        expect(find.text('00:00:00'), findsOneWidget);
      },
    );

    testWidgets(
      'should show hour, minute and second part with labels.',
      (WidgetTester tester) async {
        final DateTime time = DateTime.now();

        final CountdownTimer timer = CountdownTimer(
          startTime: time,
          endTime: time,
          widgetBuilder: (String timer) => Text(timer),
          showHour: true,
          showSecond: true,
          showTimePartLabels: true,
        );

        await tester.pumpWidget(_TestApp(timer));

        expect(find.text('00 hr 00 min 00 sec'), findsOneWidget);
      },
    );

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
