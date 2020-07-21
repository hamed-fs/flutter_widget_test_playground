import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_test_playground/chart_setting.dart';

void main() {
  group('Chart Setting Test =>', () {
    final int chartTypeOptionsCount = 2;
    final int chartDurationOptionsCount = 13;

    testWidgets(
        'setting should have $chartTypeOptionsCount chart type options.',
        (WidgetTester tester) async {
      await tester.pumpWidget(TestApp());

      expect(
        tester.widget<ListView>(find.byType(ListView).first).semanticChildCount,
        chartTypeOptionsCount,
      );
    });

    testWidgets(
        'setting should have $chartDurationOptionsCount chart duration options.',
        (WidgetTester tester) async {
      await tester.pumpWidget(TestApp());

      expect(
        tester.widget<ListView>(find.byType(ListView).last).semanticChildCount,
        chartDurationOptionsCount,
      );
    });

    testWidgets('chart type list should have horizontal scroll direction.',
        (WidgetTester tester) async {
      await tester.pumpWidget(TestApp());

      expect(
        tester.widget<ListView>(find.byType(ListView).first).scrollDirection,
        Axis.horizontal,
      );
    });

    testWidgets('chart duration list should have horizontal scroll direction.',
        (WidgetTester tester) async {
      await tester.pumpWidget(TestApp());

      expect(
        tester.widget<ListView>(find.byType(ListView).last).scrollDirection,
        Axis.horizontal,
      );
    });
  });
}

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: ChartSetting(),
      );
}
