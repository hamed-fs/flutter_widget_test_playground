import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/chart_setting/chart_setting.dart';
import 'package:flutter_widget_test_playground/enums.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter_widget_test_playground/grouped_list_view/grouped_list_view.dart';
import 'package:flutter_widget_test_playground/list_controller.dart';
import 'package:flutter_widget_test_playground/position_item.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final ListController _controller = ListController();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Code Sample',
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        home: Scaffold(
          body: SafeArea(child: _getGroupedListView()
              // Builder(
              //   builder: (BuildContext context) => Padding(
              //     padding: const EdgeInsets.all(32),
              //     child: Column(
              //       children: <Widget>[
              //         RaisedButton(
              //           child: const Text('Show Expandable Bottom Sheet'),
              //           onPressed: () => Scaffold.of(context).showBottomSheet<void>(
              //               (BuildContext context) => _buildBottomSheet()),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              ),
        ),
      );

  Widget _buildBottomSheet() => GestureDetector(
        child: ExpandableBottomSheet(
          // title: 'Chart Settings',
          // hint:
          //     'Allows you to cancel your trade within a chosen time frame should the market move against your favour.',
          // upperContent: ChartSetting(
          //   selectedChartType: ChartType.candle,
          //   selectedChartInterval: ChartInterval.fourHours,
          //   onSelectChartType: (ChartType chartType) {},
          //   onSelectChartInterval: (ChartInterval interval) {},
          // ),
          lowerContent: _getGroupedListView(),
          openMaximized: true,
        ),
        onVerticalDragStart: (_) {},
      );

  GroupedListView<dynamic, String> _getGroupedListView() {
    return GroupedListView<dynamic, String>(
      groupBy: (dynamic element) => element['group'],
      groupBuilder: (String value) => Container(
        color: Colors.black,
        child: ListTile(
          title: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      itemBuilder: (BuildContext context, dynamic element) => Container(
        color: Colors.grey,
        child: ListTile(
          title: Text(
            element['name'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      separator: Container(
        color: const Color(0xFF0E0E0E),
        height: 1,
      ),
      elements: _elements,
      enableStickyHeader: true,
      enableRefreshIndicator: true,
      refreshIndicatorDisplacement: 80,
      onRefresh: () async {
        await Future<void>.delayed(
          const Duration(seconds: 2),
          // ignore: avoid_print
          () => print('object'),
        );
      },
    );
  }

  final List<Map<String, String>> _elements = <Map<String, String>>[
    {"name": "Mcmillan Herrera", "group": "2019-08-29"},
    {"name": "Hannah Peters", "group": "2016-09-14"},
    {"name": "Gregory Charles", "group": "2014-12-10"},
    {"name": "Cooley Tran", "group": "2018-12-05"},
    {"name": "Bean Middleton", "group": "2017-12-22"},
    {"name": "Chasity Hamilton", "group": "2019-06-05"},
    {"name": "Williams Noel", "group": "2019-02-14"},
    {"name": "Isabella Walls", "group": "2016-08-31"},
    {"name": "Catherine Burns", "group": "2017-07-05"},
    {"name": "Mack Farrell", "group": "2019-04-23"},
    {"name": "Beatrice Jones", "group": "2018-03-24"},
    {"name": "Rios Alexander", "group": "2018-07-16"},
    {"name": "Peters Booker", "group": "2018-04-11"},
    {"name": "Luz Byers", "group": "2017-01-05"},
    {"name": "Rowe Hampton", "group": "2018-10-10"},
    {"name": "Carmella Martinez", "group": "2020-03-04"},
    {"name": "Gina Whitaker", "group": "2019-02-27"},
    {"name": "Lea Merritt", "group": "2018-02-01"},
    {"name": "Sheila Hutchinson", "group": "2014-11-29"},
    {"name": "Montgomery Hunt", "group": "2019-01-13"},
    {"name": "Miranda Barnett", "group": "2018-12-13"},
    {"name": "Katie Carlson", "group": "2014-08-24"},
    {"name": "Celeste Carey", "group": "2019-10-08"},
    {"name": "Shawna Sellers", "group": "2017-02-02"},
    {"name": "Valarie Bartlett", "group": "2014-11-11"},
    {"name": "Alison Spence", "group": "2015-08-30"},
    {"name": "Wilson Stafford", "group": "2018-09-25"},
    {"name": "Black Mcclain", "group": "2020-04-07"},
    {"name": "Chrystal Roach", "group": "2016-04-11"},
  ];
}
