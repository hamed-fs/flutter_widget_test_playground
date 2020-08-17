import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_test_playground/list_item/slidable_list_item.dart';

void main() {
  group('Slidable List Item Test =>', () {
    testWidgets('slidable list item should have no action.',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SlidableListItem(
            child: ListTile(title: Text('item')),
            actions: <Widget>[],
          ),
        ),
      ));

      expect(find.text('action'), findsNothing);
    });

    testWidgets('slidable list item should have one action',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SlidableListItem(
            child: ListTile(title: Text('item')),
            actions: <Widget>[InkWell(child: Text('action'))],
          ),
        ),
      ));

      expect(find.text('action'), findsOneWidget);
    });
  });
}
