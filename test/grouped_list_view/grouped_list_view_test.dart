import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_test_playground/grouped_list_view/grouped_list_view.dart';

import 'grouped_list_view_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Grouped List View =>', () {
    const int _groupCount = 3;
    const int _itemsCount = 6;

    const String _group01Name = 'group_01';
    const String _group02Name = 'group_02';
    const String _group03Name = 'group_03';

    const String _item01Name = 'user_01';
    const String _item02Name = 'user_02';
    const String _item03Name = 'user_03';
    const String _item04Name = 'user_04';
    const String _item05Name = 'user_05';
    const String _item06Name = 'user_06';

    testWidgets('list should have ${listItems.length * 2} elements.',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp());

      expect(
        tester.widget<ListView>(find.byType(ListView).last).semanticChildCount,
        listItems.length * 2,
      );
    });

    testWidgets('list should have $_groupCount groups.',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp());

      expect(find.text(_group01Name), findsOneWidget);
      expect(find.text(_group02Name), findsOneWidget);
      expect(find.text(_group03Name), findsOneWidget);
    });

    testWidgets('list should have $_itemsCount items.',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp());

      expect(find.text(_item01Name), findsOneWidget);
      expect(find.text(_item02Name), findsOneWidget);
      expect(find.text(_item03Name), findsOneWidget);
      expect(find.text(_item04Name), findsOneWidget);
      expect(find.text(_item05Name), findsOneWidget);
      expect(find.text(_item06Name), findsOneWidget);
    });

    testWidgets('list should have a sticky header and a group with same name.',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GroupedListView<dynamic, String>(
            elements: listItems,
            groupBy: (dynamic element) => element['group'],
            groupBuilder: (String value) => Text(value),
            itemBuilder: (BuildContext context, dynamic element) =>
                Text(element['name']),
            enableStickyHeader: true,
          ),
        ),
      );

      expect(find.text(_group01Name), findsNWidgets(2));
    });

    testWidgets('list should call onRefresh handler on pull down.',
        (WidgetTester tester) async {
      bool isRefreshed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: GroupedListView<dynamic, String>(
            elements: listItems,
            groupBy: (dynamic element) => element['group'],
            groupBuilder: (String value) =>
                Container(height: 100, child: Text(value)),
            itemBuilder: (BuildContext context, dynamic element) =>
                Container(height: 100, child: Text(element['name'])),
            enableRefreshIndicator: true,
            onRefresh: () async => isRefreshed = true,
          ),
        ),
      );

      await tester.drag(find.byType(Scrollable), const Offset(0, 300));
      await tester.pumpAndSettle(const Duration(milliseconds: 50));

      expect(isRefreshed, isTrue);
    });
  });
}

class _TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: GroupedListView<dynamic, String>(
          elements: listItems,
          groupBy: (dynamic element) => element['group'],
          groupBuilder: (String value) => Text(value),
          itemBuilder: (BuildContext context, dynamic element) =>
              Text(element['name']),
        ),
      );
}
