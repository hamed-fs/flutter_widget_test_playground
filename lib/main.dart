import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/chart_setting/chart_setting.dart';
import 'package:flutter_widget_test_playground/enums.dart';
import 'package:flutter_widget_test_playground/enums_extension.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter_widget_test_playground/grouped_list_view/grouped_list_view.dart';
import 'package:flutter_widget_test_playground/position_item.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Code Sample',
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        home: Scaffold(
          // backgroundColor: Colors.green,
          // body: SafeArea(
          //   child: GroupedListView<dynamic, String>(
          //     elements: _elements,
          //     separatorHeight: 52,
          //     tileHeight: 60,
          //     groupBy: (dynamic element) => element['group'],
          //     groupBuilder: (String value) => Container(
          //       height: 52,
          //       width: double.infinity,
          //       color: const Color(0xFF0E0E0E),
          //       padding: const EdgeInsets.only(left: 16, top: 24),
          //       child: Text(
          //         value,
          //         style: const TextStyle(
          //           color: Color(0xFFC2C2C2),
          //           fontSize: 14,
          //         ),
          //       ),
          //     ),
          //     itemBuilder: (BuildContext context, dynamic element) =>
          //         PositionItem(
          //       contract: Contract(),
          //     ),
          //   ),
          // ),
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

  List<Map<String, String>> _elements = <Map<String, String>>[
    // ignore: always_specify_types
    {'name': 'user_01', 'group': 'group_01'},
    {'name': 'user_01', 'group': 'group_01'},
    {'name': 'user_01', 'group': 'group_01'},
    {'name': 'user_01', 'group': 'group_01'},
    {'name': 'user_01', 'group': 'group_01'},

    {'name': 'user_01', 'group': 'group_02'},
    {'name': 'user_01', 'group': 'group_02'},
    {'name': 'user_01', 'group': 'group_02'},
    {'name': 'user_01', 'group': 'group_02'},
    {'name': 'user_01', 'group': 'group_02'},

    {'name': 'user_01', 'group': 'group_03'},
    {'name': 'user_01', 'group': 'group_03'},
    {'name': 'user_01', 'group': 'group_03'},
    {'name': 'user_01', 'group': 'group_03'},
    {'name': 'user_01', 'group': 'group_03'},

    {'name': 'user_01', 'group': 'group_04'},
    {'name': 'user_01', 'group': 'group_04'},
    {'name': 'user_01', 'group': 'group_04'},
    {'name': 'user_01', 'group': 'group_04'},
    {'name': 'user_01', 'group': 'group_04'},

    {'name': 'user_01', 'group': 'group_05'},
    {'name': 'user_01', 'group': 'group_05'},
    {'name': 'user_01', 'group': 'group_05'},
    {'name': 'user_01', 'group': 'group_05'},
    {'name': 'user_01', 'group': 'group_05'},

    {'name': 'user_01', 'group': 'group_06'},
    {'name': 'user_01', 'group': 'group_06'},
    {'name': 'user_01', 'group': 'group_06'},
    {'name': 'user_01', 'group': 'group_06'},
    {'name': 'user_01', 'group': 'group_06'},

    {'name': 'user_01', 'group': 'group_07'},
    {'name': 'user_01', 'group': 'group_07'},
    {'name': 'user_01', 'group': 'group_07'},
    {'name': 'user_01', 'group': 'group_07'},
    {'name': 'user_01', 'group': 'group_07'},

    {'name': 'user_01', 'group': 'group_08'},
    {'name': 'user_01', 'group': 'group_08'},
    {'name': 'user_01', 'group': 'group_08'},
    {'name': 'user_01', 'group': 'group_08'},
    {'name': 'user_01', 'group': 'group_08'},

    {'name': 'user_01', 'group': 'group_09'},
    {'name': 'user_01', 'group': 'group_09'},
    {'name': 'user_01', 'group': 'group_09'},
    {'name': 'user_01', 'group': 'group_09'},
    {'name': 'user_01', 'group': 'group_09'},

    {'name': 'user_01', 'group': 'group_10'},
    {'name': 'user_01', 'group': 'group_10'},
    {'name': 'user_01', 'group': 'group_10'},
    {'name': 'user_01', 'group': 'group_10'},
    {'name': 'user_01', 'group': 'group_10'},
    {'name': 'user_01', 'group': 'group_10'},
    {'name': 'user_01', 'group': 'group_10'},
    {'name': 'user_01', 'group': 'group_10'},
    {'name': 'user_01', 'group': 'group_10'},
  ];

  ExpandableBottomSheet _buildExpandableBottomSheet() => ExpandableBottomSheet(
        onOpen: () => print('OPEN!'),
        onClose: () => print('CLOSE!'),
        onDismiss: () => print('DISMISS!'),
        onToggle: () => print('TOGGLE!'),
        title: 'Chart Settings',
        hint:
            'Allows you to cancel your trade within a chosen time frame should the market move against your favour.',
        upperContent: ChartSetting(
          selectedChartType: ChartType.candle,
          selectedChartInterval: ChartInterval.fourHours,
          onSelectChartType: (ChartType chartType) {
            print(chartType);

            setState(() {
              _elements = [..._elements, ..._elements];
            });
          },
          onSelectChartInterval: (ChartInterval interval) =>
              print(interval.toMilliseconds()),
        ),
        lowerContent: GroupedListView<dynamic, String>(
          separatorHeight: 50,
          tileHeight: 66,
          // sort: true,
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
          itemBuilder: (BuildContext context, dynamic element) => PositionItem(
            contract: Contract(),
          ),
          // separator: Container(
          //   color: const Color(0xFF0E0E0E),
          //   height: 1,
          // ),
          elements: _elements,
          // order: GroupedListViewOrder.ascending,
        ),
        // lowerContent: getListItems(),
        // lowerContent: ListView.separated(
        //   itemCount: 100,
        //   itemBuilder: (BuildContext context, int index) => PositionItem(
        //     contract: Contract(),
        //     key: UniqueKey(),
        //     onTap: (Contract contract) => print(contract.toString()),
        //   ),
        //   separatorBuilder: (BuildContext context, int item) => Container(
        //     color: const Color(0xFF0E0E0E),
        //     height: 1,
        //   ),
        // ),
        // maxHeight: 700,
        openMaximized: true,
      );
}
