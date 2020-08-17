import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_widget_test_playground/list_item/list_header.dart';

void main() {
  group('List Header =>', () {
    testWidgets(
      'should show presented title in widget',
      (WidgetTester tester) async {
        const String title = 'header title';

        await tester.pumpWidget(
          const MaterialApp(
            home: ListHeader(title: title),
          ),
        );

        expect(find.text(title), findsOneWidget);
        expect(find.text(title), findsOneWidget);
      },
    );
  });
}
