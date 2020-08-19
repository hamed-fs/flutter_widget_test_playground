// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_widget_test_playground/chart_setting/chart_setting.dart';

void main() {
  group('Chart Setting Test =>', () {
    const int chartTypeOptionsCount = 2;
    const int chartDurationOptionsCount = 13;

    const String areaChartTypeIconSemanticsLabel = 'Area Chart Icon';
    const String candleChartTypeIconSemanticsLabel = 'Candle Chart Icon';

    testWidgets(
        'setting should have $chartTypeOptionsCount chart type options.',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp());

      final WidgetPredicate areaChartTypeIconWidget = (Widget widget) =>
          widget is SvgPicture &&
          widget.semanticsLabel == areaChartTypeIconSemanticsLabel;

      final WidgetPredicate candleChartTypeIconWidget = (Widget widget) =>
          widget is SvgPicture &&
          widget.semanticsLabel == candleChartTypeIconSemanticsLabel;

      expect(find.byWidgetPredicate(areaChartTypeIconWidget), findsOneWidget);
      expect(find.byWidgetPredicate(candleChartTypeIconWidget), findsOneWidget);

      expect(
        tester.widget<ListView>(find.byType(ListView).first).semanticChildCount,
        chartTypeOptionsCount,
      );
    });

    testWidgets(
        'setting should have $chartDurationOptionsCount chart duration options.',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp());

      expect(
        tester.widget<ListView>(find.byType(ListView).last).semanticChildCount,
        chartDurationOptionsCount,
      );
    });

    testWidgets('chart type list should have horizontal scroll direction.',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp());

      expect(
        tester.widget<ListView>(find.byType(ListView).first).scrollDirection,
        Axis.horizontal,
      );
    });

    testWidgets('chart duration list should have horizontal scroll direction.',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp());

      expect(
        tester.widget<ListView>(find.byType(ListView).last).scrollDirection,
        Axis.horizontal,
      );
    });
  });
}

class _TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const MaterialApp(home: ChartSetting());
}
