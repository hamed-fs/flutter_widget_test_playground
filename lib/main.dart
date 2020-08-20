import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/api/contract/models/cancellation_info_model.dart';
import 'package:flutter_deriv_api/api/contract/operation/open_contract.dart';
import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';
import 'package:flutter_widget_test_playground/chart_setting/chart_setting.dart';
import 'package:flutter_widget_test_playground/enums.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter_widget_test_playground/grouped_list_view/grouped_list_view.dart';
import 'package:flutter_widget_test_playground/list_item/list_header.dart';
import 'package:flutter_widget_test_playground/list_item/position_item.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSticky = true;
  final ThemeProvider _themeProvider = ThemeProvider();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

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
          // appBar: AppBar(),
          key: key,
          body: SafeArea(
            child: Builder(
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: const Text('Show Expandable Bottom Sheet'),
                      onPressed: () => showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => _buildBottomSheet(),
                      ),
                    ),

                    // Scaffold.of(context).showBottomSheet<void>(
                    //     (BuildContext context) => _buildBottomSheet()),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildBottomSheet() => GestureDetector(
        child: ExpandableBottomSheet(
          onClose: () => print('Close'),
          onOpen: () => print('Open'),
          onDismiss: () => print('Dismiss'),
          onToggle: () => print('Toggle'),
          openMaximized: true,
          showToggler: true,
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
          leftAction: RawMaterialButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(5),
            child: Text(
              'Clear',
              style: _themeProvider.textStyle(
                textStyle: TextStyles.subheading,
                color: _themeProvider.brandCoralColor,
              ),
            ),
            onPressed: () {},
          ),
          rightAction: RaisedButton(
            child: Text(
              'Right',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => print('object R'),
          ),
        ),
        onVerticalDragStart: (_) {},
      );

  final OpenContract openContractWithProfit = OpenContract(
    contractType: 'MULTUP',
    bidPrice: 13.1,
    profit: 25.5,
    currency: 'USD',
    multiplier: 30,
    cancellation: CancellationInfoModel(
      1.2,
      DateTime.now().add(Duration(seconds: Random().nextInt(120))),
    ),
  );

  GroupedListView<dynamic, String> _getGroupedListView() =>
      GroupedListView<dynamic, String>(
        groupBy: (dynamic element) => element['group'],
        groupBuilder: (String value) => ListHeader(title: value),
        itemBuilder: (BuildContext context, dynamic element) => PositionItem(
          contract: openContractWithProfit,
          actions: <Widget>[
            Container(
              height: 60,
              width: 120,
              color: Random().nextBool()
                  ? _themeProvider.accentRedColor
                  : _themeProvider.accentGreenColor,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: const Center(
                    child: Text(
                      'CLOSE',
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () => print(element),
                ),
              ),
            ),
          ],
        ),
        separator: Container(
          color: _themeProvider.base08Color,
          height: 1,
        ),
        elements: _elements,
        hasStickyHeader: _isSticky,
        hasRefreshIndicator: true,
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
