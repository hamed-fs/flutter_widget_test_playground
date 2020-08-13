import 'package:flutter/material.dart';
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
int counter = 0;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Code Sample',
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Show Expandable Bottom Sheet'),
                    onPressed: () => Scaffold.of(context).showBottomSheet<void>(
                        (BuildContext context) => _buildBottomSheet()),
                  ),
                  RaisedButton(
                    child: const Text('Add Item'),
                    onPressed: () {
                      _controller.list = [_elements[counter++]];
                    },
                  ),
                  // _buildSimpleList()
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildSimpleList() => StreamBuilder<List<Map<String, String>>>(
        stream: _controller.streamController.stream,
        builder: (context, snapshot) {
          return Container(
            color: Colors.red,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot?.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(snapshot.data[index]['name']),
              ),
            ),
          );
        },
      );

  Widget _buildBottomSheet() => StreamBuilder<List<Map<String, String>>>(
        stream: _controller.streamController.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Map<String, String>>> snapshot,
        ) =>
            GestureDetector(
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
            lowerContent: snapshot.hasData
                ? GroupedListView<dynamic, String>(
                    sort: true,
                    groupBy: (dynamic element) => element['group'],
                    groupBuilder: (String value) => Container(
                      height: 52,
                      width: double.infinity,
                      color: const Color(0xFF0E0E0E),
                      padding: const EdgeInsets.only(left: 16, top: 24),
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xFFC2C2C2),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    itemBuilder: (BuildContext context, dynamic element) =>
                        PositionItem(
                      contract: Contract(),
                    ),
                    separator: Container(
                      color: const Color(0xFF0E0E0E),
                      height: 1,
                    ),
                    elements: snapshot.data,
                    enableStickyHeader: true,
                    hasRefreshIndicator: true,
                    refreshIndicatorDisplacement: 80,
                    onRefresh: () async {
                      await Future<void>.delayed(
                        const Duration(seconds: 2),
                        // ignore: avoid_print
                        () => print('object'),
                      );
                    },
                  )
                : Container(),
            maxHeight: 500,
            openMaximized: true,
          ),
          onVerticalDragStart: (_) {},
        ),
      );

  final List<Map<String, String>> _elements = <Map<String, String>>[
    <String, String>{'name': 'user_01', 'group': 'group_01'},
    <String, String>{'name': 'user_02', 'group': 'group_01'},
    <String, String>{'name': 'user_03', 'group': 'group_02'},
    <String, String>{'name': 'user_04', 'group': 'group_02'},
    <String, String>{'name': 'user_05', 'group': 'group_02'},
    <String, String>{'name': 'user_06', 'group': 'group_03'},
  ];
}
