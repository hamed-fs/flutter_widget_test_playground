import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_widget_test_playground/expandable_bottom_sheet.dart';

void main() {
  group('Expandable Bottom Sheet =>', () {
    Key widgetKey;
    Key togglerKey;
    Key upperContentKey;
    Key lowerContentKey;
    ExpandableBottomSheetController controller;

    setUpAll(() {
      widgetKey = UniqueKey();
      togglerKey = UniqueKey();
      upperContentKey = UniqueKey();
      lowerContentKey = UniqueKey();

      controller = ExpandableBottomSheetController();
    });

    testWidgets('Open and Close on Tap Test.', (WidgetTester tester) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        key: widgetKey,
        controller: controller,
        toggler: Container(
          key: togglerKey,
          child: Text('toggler'),
        ),
        upperContent: Container(
          key: upperContentKey,
        ),
        lowerContent: Container(
          key: lowerContentKey,
        ),
      );

      final Finder togglerFinder = find.byKey(togglerKey);

      await tester.pumpWidget(TestApp(bottomSheet));

      await tester.tap(togglerFinder);
      await tester.pump();
      expect(controller.isOpened, isTrue);

      await tester.tap(togglerFinder);
      await tester.pump();
      expect(controller.isOpened, isFalse);
    });

    testWidgets('Open When Drag Up Test.', (WidgetTester tester) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        key: widgetKey,
        controller: controller,
        toggler: Container(
          key: togglerKey,
          child: Text('toggler'),
        ),
        upperContent: Container(
          key: upperContentKey,
        ),
        lowerContent: Container(
          key: lowerContentKey,
        ),
      );

      await tester.pumpWidget(TestApp(bottomSheet));

      await tester.drag(find.byKey(togglerKey), Offset(0.0, -100.0));
      await tester.pump();
      expect(controller.isOpened, isTrue);
    });

    testWidgets('Close When Drag Down Test.', (WidgetTester tester) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        key: widgetKey,
        controller: controller,
        toggler: Container(
          key: togglerKey,
          child: Text('toggler'),
        ),
        upperContent: Container(
          key: upperContentKey,
        ),
        lowerContent: Container(
          key: lowerContentKey,
        ),
      );

      await tester.pumpWidget(TestApp(bottomSheet));

      await tester.drag(find.byKey(togglerKey), Offset(0.0, 100.0));
      await tester.pump();
      expect(controller.isOpened, isFalse);
    });

    testWidgets('Call "onShow()" Callback When is Opened Test.', (
      WidgetTester tester,
    ) async {
      int timesExecuted = 0;

      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        key: widgetKey,
        controller: controller,
        toggler: Container(
          key: togglerKey,
          child: Text('toggler'),
        ),
        upperContent: Container(
          key: upperContentKey,
        ),
        lowerContent: Container(
          key: lowerContentKey,
        ),
        onShow: () => timesExecuted++,
      );

      final Finder togglerFinder = find.byKey(togglerKey);

      await tester.pumpWidget(TestApp(bottomSheet));

      await tester.drag(togglerFinder, Offset(0.0, -100.0));
      await tester.pump();
      expect(timesExecuted, 1);

      await tester.tap(togglerFinder);
      await tester.pump();
      await tester.tap(togglerFinder);
      await tester.pump();
      expect(timesExecuted, 2);

      await tester.tap(togglerFinder);
      await tester.pump();
      controller.show();
      expect(timesExecuted, 3);
    });

    testWidgets('Call "onHide()" Callback When is Closed Test.', (
      WidgetTester tester,
    ) async {
      int timesExecuted = 0;

      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        key: widgetKey,
        controller: controller,
        toggler: Container(
          key: togglerKey,
          child: Text('toggler'),
        ),
        upperContent: Container(
          key: upperContentKey,
        ),
        lowerContent: Container(
          key: lowerContentKey,
        ),
        onHide: () => timesExecuted++,
      );

      final Finder togglerFinder = find.byKey(togglerKey);

      await tester.pumpWidget(TestApp(bottomSheet));

      await tester.tap(togglerFinder);
      await tester.pump();

      await tester.drag(togglerFinder, Offset(0.0, 100.0));
      await tester.pump();
      expect(timesExecuted, 1);

      await tester.tap(togglerFinder);
      await tester.pump();
      await tester.tap(togglerFinder);
      await tester.pump();
      expect(timesExecuted, 2);

      await tester.tap(togglerFinder);
      await tester.pump();
      controller.hide();
      expect(timesExecuted, 3);
    });

    testWidgets('Set Title Test.', (
      WidgetTester tester,
    ) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        key: widgetKey,
        controller: controller,
        title: 'title',
        toggler: Container(
          key: togglerKey,
          child: Text('toggler'),
        ),
        upperContent: Container(
          key: upperContentKey,
        ),
        lowerContent: Container(
          key: lowerContentKey,
        ),
      );

      await tester.pumpWidget(TestApp(bottomSheet));

      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('Set and Open Hint Test.', (
      WidgetTester tester,
    ) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        key: widgetKey,
        controller: controller,
        title: 'title',
        hint: 'hint',
        toggler: Container(
          key: togglerKey,
          child: Text('toggler'),
        ),
        upperContent: Container(
          key: upperContentKey,
        ),
        lowerContent: Container(
          key: lowerContentKey,
        ),
      );

      await tester.pumpWidget(TestApp(bottomSheet));

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pump();
      expect(find.text('hint'), findsOneWidget);
    });

    group('Expandable Bottom Sheet Bloc =>', () {
      ExpandableBottomSheetBloc bloc;

      setUp(() {
        bloc = ExpandableBottomSheetBloc();
      });

      test('Emit Values for Height Test.', () async {
        final expected = [0.0, 100.0, 150.0];

        expectLater(bloc.height, emitsInOrder(expected));

        bloc.dispatch(0.0);
        bloc.dispatch(100.0);
        bloc.dispatch(150.0);
      });

      test('Emit Values for Visibility Test.', () {
        final expected = [false, true, false];

        expectLater(bloc.isOpen, emitsInOrder(expected));

        bloc.dispatch(0.0);
        bloc.dispatch(100.0);
        bloc.dispatch(0.0);
      });
    });
  });
}

class TestApp extends StatefulWidget {
  final ExpandableBottomSheet bottomSheet;

  TestApp(this.bottomSheet);

  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(bottomSheet: widget.bottomSheet),
      );
}
