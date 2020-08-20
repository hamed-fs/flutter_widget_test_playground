// ignore_for_file: avoid_as
// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_deriv_theme/theme_provider.dart';
import 'package:flutter_widget_test_playground/list_item/position_item.dart';

import 'position_item_data.dart';

void main() {
  group('Position Item Test =>', () {
    const String symbolIconSemanticsLabel = 'Symbol Icon';
    const String contractTypeIconSemanticsLabel = 'Contract Type Icon';
    const String dealCancellationIndicatorSemanticsLabel =
        'Deal Cancellation Indicator';

    ThemeProvider themeProvider;

    WidgetPredicate symbolIconWidget;
    WidgetPredicate contractTypeIconWidget;

    setUpAll(() {
      themeProvider = ThemeProvider();

      symbolIconWidget = (Widget widget) =>
          widget is SvgPicture &&
          widget.semanticsLabel == symbolIconSemanticsLabel;

      contractTypeIconWidget = (Widget widget) =>
          widget is SvgPicture &&
          widget.semanticsLabel == contractTypeIconSemanticsLabel;
    });

    testWidgets('open contract with profit test.', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PositionItem(
              contract: openContractWithProfit,
            ),
          ),
        ),
      );

      final Finder bidPriceWidget = find.text('+25.50 USD');

      expect(find.byWidgetPredicate(symbolIconWidget), findsOneWidget);
      expect(find.byWidgetPredicate(contractTypeIconWidget), findsOneWidget);

      expect(find.byType(Text), findsNWidgets(3));

      expect(find.text('13.10 USD'), findsOneWidget);
      expect(find.text('x30'), findsOneWidget);

      expect(bidPriceWidget, findsOneWidget);
      expect(tester.firstWidget<Text>(bidPriceWidget).style.color,
          themeProvider.accentGreenColor);
    });

    testWidgets('open contract with loss test.', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PositionItem(
              contract: openContractWithLoss,
            ),
          ),
        ),
      );

      final Finder bidPriceWidget = find.text('-10.25 USD');

      expect(find.byWidgetPredicate(symbolIconWidget), findsOneWidget);
      expect(find.byWidgetPredicate(contractTypeIconWidget), findsOneWidget);

      expect(find.byType(Text), findsNWidgets(3));

      expect(find.text('13.10 USD'), findsOneWidget);
      expect(find.text('x30'), findsOneWidget);

      expect(bidPriceWidget, findsOneWidget);
      expect(tester.firstWidget<Text>(bidPriceWidget).style.color,
          themeProvider.accentRedColor);
    });

    testWidgets('open contract with deal cancellation information test.',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PositionItem(
              contract: openContractWithCancellationInformation,
            ),
          ),
        ),
      );

      final Finder bidPriceWidget = find.text('+25.50 USD');
      final WidgetPredicate dealCancellationIndicatorIconWidget =
          (Widget widget) =>
              widget is SvgPicture &&
              widget.semanticsLabel == dealCancellationIndicatorSemanticsLabel;

      expect(find.byWidgetPredicate(symbolIconWidget), findsOneWidget);
      expect(find.byWidgetPredicate(contractTypeIconWidget), findsOneWidget);
      expect(
        find.byWidgetPredicate(dealCancellationIndicatorIconWidget),
        findsOneWidget,
      );

      expect(find.byType(Text), findsNWidgets(4));

      expect(find.text('13.10 USD'), findsOneWidget);
      expect(find.text('x30'), findsOneWidget);

      expect(bidPriceWidget, findsOneWidget);
      expect(tester.firstWidget<Text>(bidPriceWidget).style.color,
          themeProvider.accentGreenColor);
    });

    testWidgets('closed contract with deal cancellation information test.',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PositionItem(
              contract: openContractWithCancellationInformation,
            ),
          ),
        ),
      );

      final Finder bidPriceWidget = find.text('+25.50 USD');
      final WidgetPredicate dealCancellationIndicatorIconWidget =
          (Widget widget) =>
              widget is SvgPicture &&
              widget.semanticsLabel == dealCancellationIndicatorSemanticsLabel;

      expect(find.byWidgetPredicate(symbolIconWidget), findsOneWidget);
      expect(find.byWidgetPredicate(contractTypeIconWidget), findsOneWidget);
      expect(
        find.byWidgetPredicate(dealCancellationIndicatorIconWidget),
        findsOneWidget,
      );

      expect(find.byType(Text), findsNWidgets(4));

      expect(find.text('13.10 USD'), findsOneWidget);
      expect(find.text('x30'), findsOneWidget);
      expect(find.text('05 min'), findsOneWidget);

      expect(bidPriceWidget, findsOneWidget);
      expect(tester.firstWidget<Text>(bidPriceWidget).style.color,
          themeProvider.accentGreenColor);
    });
  });
}
