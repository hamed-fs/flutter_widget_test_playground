import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_widget_test_playground/expandable_bottom_sheet/expandable_bottom_sheet.dart';

void main() {
  group('Expandable Bottom Sheet =>', () {
    ExpandableBottomSheetController controller;

    const String title = 'Expandable Bottom Sheet Title';
    const String hint = 'Expandable Bottom Sheet Hint';

    setUpAll(() => controller = ExpandableBottomSheetController());

    testWidgets('should open and close when tap on toggler.',
        (WidgetTester tester) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        controller: controller,
        title: title,
        upperContent: Container(),
        lowerContent: Container(),
      );

      final Finder togglerFinder = find.text(title);

      await tester.pumpWidget(_TestApp(bottomSheet));

      await tester.tap(togglerFinder);
      await tester.pump();
      expect(controller.isOpened, isTrue);

      await tester.tap(togglerFinder);
      await tester.pump();
      expect(controller.isOpened, isFalse);
    });

    testWidgets('should open when drag up toggler.',
        (WidgetTester tester) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        controller: controller,
        title: title,
        upperContent: Container(),
        lowerContent: Container(),
      );

      await tester.pumpWidget(_TestApp(bottomSheet));

      await tester.drag(find.text(title), const Offset(0, -100));
      await tester.pump();
      expect(controller.isOpened, isTrue);
    });

    testWidgets('should close when drag down toggler.',
        (WidgetTester tester) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        controller: controller,
        title: title,
        upperContent: Container(),
        lowerContent: Container(),
      );

      await tester.pumpWidget(_TestApp(bottomSheet));

      await tester.drag(find.text(title), const Offset(0, 100));
      await tester.pump();
      expect(controller.isOpened, isFalse);
    });

    testWidgets('should set title when `title` has value.', (
      WidgetTester tester,
    ) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        controller: controller,
        title: title,
        upperContent: Container(),
        lowerContent: Container(),
      );

      await tester.pumpWidget(_TestApp(bottomSheet));

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should set and open hint when `hint` has value.', (
      WidgetTester tester,
    ) async {
      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        controller: controller,
        title: title,
        hint: hint,
        upperContent: Container(),
        lowerContent: Container(),
      );

      await tester.pumpWidget(_TestApp(bottomSheet));

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pump();
      expect(find.text(hint), findsOneWidget);
    });

    testWidgets('should call `onOpen()` callback on bottom sheet open.',
        (WidgetTester tester) async {
      int timesExecuted = 0;

      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        controller: controller,
        title: title,
        upperContent: Container(),
        lowerContent: Container(),
        onOpen: () => timesExecuted++,
      );

      final Finder togglerFinder = find.text(title);

      await tester.pumpWidget(_TestApp(bottomSheet));

      await tester.drag(togglerFinder, const Offset(0, -100));
      await tester.pump();
      expect(timesExecuted, 1);

      await tester.tap(togglerFinder);
      await tester.pump();
      await tester.tap(togglerFinder);
      await tester.pump();
      expect(timesExecuted, 2);

      await tester.tap(togglerFinder);
      await tester.pump();
      controller.open();
      expect(timesExecuted, 3);
    });

    testWidgets('should call `onClose()` callback on bottom sheet close.',
        (WidgetTester tester) async {
      int timesExecuted = 0;

      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        controller: controller,
        title: title,
        upperContent: Container(),
        lowerContent: Container(),
        onClose: () => timesExecuted++,
      );

      final Finder togglerFinder = find.text(title);

      await tester.pumpWidget(_TestApp(bottomSheet));

      await tester.tap(togglerFinder);
      await tester.pump();

      await tester.drag(togglerFinder, const Offset(0, 100));
      await tester.pump();
      expect(timesExecuted, 1);

      await tester.tap(togglerFinder);
      await tester.pump();
      await tester.tap(togglerFinder);
      await tester.pump();
      expect(timesExecuted, 2);

      await tester.tap(togglerFinder);
      await tester.pump();
      controller.close();
      expect(timesExecuted, 3);
    });

    testWidgets('should call `onDismiss()` callback on bottom sheet dismiss.',
        (WidgetTester tester) async {
      bool isDismissed = false;

      final ExpandableBottomSheet bottomSheet = ExpandableBottomSheet(
        controller: controller,
        title: title,
        upperContent: Container(),
        lowerContent: Container(),
        onDismiss: () => isDismissed = true,
      );

      await tester.pumpWidget(_TestApp(bottomSheet));

      await tester.drag(find.text(title), const Offset(0, 100));
      await tester.pump();
      expect(isDismissed, isTrue);
    });

    group('Expandable Bottom Sheet Bloc =>', () {
      ExpandableBottomSheetBloc bloc;

      setUp(() {
        bloc = ExpandableBottomSheetBloc();
      });

      test('should emit right values for height.', () {
        const List<double> expected = <double>[0, 100, 150];

        expectLater(bloc.height, emitsInOrder(expected));

        bloc..dispatch(0)..dispatch(100)..dispatch(150);
      });

      test('should emit right values for visibility.', () {
        const List<bool> expected = <bool>[false, true, false];

        expectLater(bloc.isOpen, emitsInOrder(expected));

        bloc..dispatch(0)..dispatch(100)..dispatch(0);
      });
    });
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp(this.bottomSheet);

  final ExpandableBottomSheet bottomSheet;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(bottomSheet: bottomSheet),
      );
}
