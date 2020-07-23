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
          // bottomSheet: _buildExpandableBottomSheet(),
          // appBar: AppBar(title: const Text(_title)),
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
      hint:
          'Allows you to cancel your trade within a chosen time frame should the market move against your favour.',
      // toggler: Text(
      //   'toggler',
      //   style: TextStyle(color: Colors.white),
      // ),
      upperContent: const ChartSetting(),
      lowerContent: ListView(
        children: const <Widget>[
          PositionItem(),
          SizedBox(height: 1),
          PositionItem(),
          SizedBox(height: 1),
          PositionItem(),
          SizedBox(height: 1),
          PositionItem(),
          SizedBox(height: 1),
          PositionItem(),
          SizedBox(height: 1),
          PositionItem(),
          SizedBox(height: 1),
          PositionItem(),
          SizedBox(height: 1),
          PositionItem(),
          SizedBox(height: 1),
          PositionItem(),
          SizedBox(height: 1),
        ],
      ),
      // upperContent: Container(
      //   height: 150.0,
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Container(
      //       color: Colors.blueGrey,
      //       child: Center(
      //         child: Text(
      //           'MAIN DATA...',
      //           style:
      //               TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // lowerContent: Builder(
      //   builder: (context) => SingleChildScrollView(
      //     child: Container(
      //       child: Center(
      //           child: Column(
      //         children: <Widget>[
      //           for (var i = 0; i < 100; i++)
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Container(
      //                 color: Colors.grey,
      //                 child: ListTile(
      //                   title: Text(
      //                     'EXTENDED DATA ${i + 1}...',
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //         ],
      //       )),
      //     ),
      //   ),
      // ),
    );
