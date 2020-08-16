import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/api/contract/models/cancellation_info_model.dart';
import 'package:flutter_deriv_api/api/contract/operation/open_contract.dart';
import 'package:flutter_widget_test_playground/chart_setting/chart_setting.dart';
import 'package:flutter_widget_test_playground/enums.dart';
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
  bool _isSticky = true;

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
                ],
              ),
            ),
          ),
        ),
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
        itemBuilder: (BuildContext context, dynamic element) => PositionItem(
          contract: OpenContract(
            contractType: 'MULTUP',
            profit: -123,
            bidPrice: 13,
            currency: 'USD',
            multiplier: 30,
            cancellation: CancellationInfoModel(
              1.2,
              DateTime.now().add(const Duration(minutes: 3)),
            ),
          ),
          actions: <Widget>[
            Container(
              height: 60,
              width: 120,
              color: const Color(0xFF00A79E),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: const Center(
                    child: Text(
                      'CLOSE',
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  onTap: () => print(element),
                ),
              ),
            ),
          ],
        ),
        separator: Container(
          color: Colors.blue,
          height: 1,
        ),
        elements: _elements,
        hasStickyHeader: _isSticky,
        hasRefreshIndicator: true,
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
