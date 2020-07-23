import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/chart_setting.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet.dart';
import 'package:flutter_widget_test_playground/position_item.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: _title,
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        home: Scaffold(
          backgroundColor: Colors.green,
          body: Builder(
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(32),
              child: RaisedButton(
                child: const Text('Show Expandable Bottom Sheet'),
                onPressed: () => Scaffold.of(context).showBottomSheet<void>(
                  (BuildContext context) => GestureDetector(
                    child: _buildExpandableBottomSheet(),
                    onVerticalDragStart: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

ExpandableBottomSheet _buildExpandableBottomSheet() => ExpandableBottomSheet(
      controller: ExpandableBottomSheetController(),
      title: 'Deal Cancellation',
      hint: '''
              Allows you to cancel your trade within a
              chosen time frame should the market
              move against your favour.
            ''',
      upperContent: const ChartSetting(),
      lowerContent: ListView.separated(
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) =>
            PositionItem(key: UniqueKey()),
        separatorBuilder: (BuildContext context, int item) => Container(
          color: const Color(0xFF0E0E0E),
          height: 1,
        ),
      ),
    );
