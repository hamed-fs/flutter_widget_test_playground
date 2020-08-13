import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/chart_setting/chart_setting.dart';
import 'package:flutter_widget_test_playground/enums.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter_widget_test_playground/grouped_list_view/grouped_list_view.dart';
import 'package:flutter_widget_test_playground/list_controller.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final ListController _controller = ListController();

class _MyAppState extends State<MyApp> {
  bool _isSticky = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Code Sample',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('List View Test'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  _isSticky ? Icons.blur_on : Icons.blur_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  _isSticky = !_isSticky;
                  setState(() {});
                },
                tooltip: 'Sticky Header',
              )
            ],
          ),
          body: SafeArea(
            child: _getGroupedListView(),
          ),
        ),
        //   Builder(
        //     builder: (BuildContext context) => Padding(
        //       padding: const EdgeInsets.all(32),
        //       child: Column(
        //         children: <Widget>[
        //           RaisedButton(
        //             child: const Text('Show Expandable Bottom Sheet'),
        //             onPressed: () => Scaffold.of(context).showBottomSheet<void>(
        //                 (BuildContext context) => _buildBottomSheet()),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      );

  Widget _buildBottomSheet() => GestureDetector(
        child: ExpandableBottomSheet(
          title: 'Chart Settings',
          hint:
              'Allows you to cancel your trade within a chosen time frame should the market move against your favour.',
          upperContent: ChartSetting(
            selectedChartType: ChartType.candle,
            selectedChartInterval: ChartInterval.fourHours,
            onSelectChartType: (ChartType chartType) {},
            onSelectChartInterval: (ChartInterval interval) {},
          ),
          lowerContent: _getGroupedListView(),
          openMaximized: true,
        ),
        onVerticalDragStart: (_) {},
      );

  GroupedListView<dynamic, String> _getGroupedListView() =>
      GroupedListView<dynamic, String>(
        groupBy: (dynamic element) => element['group'],
        groupBuilder: (String value) => Container(
          color: Colors.blue,
          child: ListTile(
            title: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        itemBuilder: (BuildContext context, dynamic element) => Container(
          color: Colors.white,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              child: Icon(Icons.adb),
            ),
            title: Text(
              element['name'],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              element['group'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
        separator: Container(
          color: Colors.blue,
          height: 1,
        ),
        elements: _elements,
        enableStickyHeader: _isSticky,
        enableRefreshIndicator: true,
        refreshIndicatorDisplacement: 60,
        onRefresh: () async {
          await Future<void>.delayed(
            const Duration(seconds: 2),
            // ignore: avoid_print
            () => print('object'),
          );
        },
      );

  final List<Map<String, String>> _elements = <Map<String, String>>[
    <String, String>{'name': 'Item 01', 'group': 'Group 01'},
    <String, String>{'name': 'Item 02', 'group': 'Group 01'},
    <String, String>{'name': 'Item 03', 'group': 'Group 02'},
    <String, String>{'name': 'Item 04', 'group': 'Group 02'},
    <String, String>{'name': 'Item 05', 'group': 'Group 02'},
    <String, String>{'name': 'Item 06', 'group': 'Group 03'},
    <String, String>{'name': 'Item 07', 'group': 'Group 03'},
    <String, String>{'name': 'Item 08', 'group': 'Group 03'},
    <String, String>{'name': 'Item 09', 'group': 'Group 03'},
    <String, String>{'name': 'Item 10', 'group': 'Group 03'},
    <String, String>{'name': 'Item 11', 'group': 'Group 04'},
    <String, String>{'name': 'Item 12', 'group': 'Group 04'},
    <String, String>{'name': 'Item 13', 'group': 'Group 04'},
    <String, String>{'name': 'Item 14', 'group': 'Group 04'},
    <String, String>{'name': 'Item 15', 'group': 'Group 04'},
    <String, String>{'name': 'Item 16', 'group': 'Group 04'},
    <String, String>{'name': 'Item 17', 'group': 'Group 05'},
    <String, String>{'name': 'Item 18', 'group': 'Group 05'},
    <String, String>{'name': 'Item 19', 'group': 'Group 05'},
    <String, String>{'name': 'Item 20', 'group': 'Group 05'},
  ];
}
