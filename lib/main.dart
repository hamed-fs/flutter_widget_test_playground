import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/chart_setting.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet.dart';
import 'package:flutter_widget_test_playground/grouped_list_view.dart';
import 'package:flutter_widget_test_playground/position_item.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<ContractExpand> sectionList = MockData.getExampleSections();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Code Sample',
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

  final List<Map<String, String>> _elements = <Map<String, String>>[
    // ignore: always_specify_types
    {'name': 'John', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Will', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Beth', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Miranda', 'group': '03 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Mike', 'group': '02 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Danny', 'group': '03 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'John', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Will', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Beth', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Miranda', 'group': '03 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Mike', 'group': '02 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Danny', 'group': '03 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'John', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Will', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Beth', 'group': '01 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Miranda', 'group': '03 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Mike', 'group': '02 Jan 2020'},
    // ignore: always_specify_types
    {'name': 'Danny', 'group': '03 Jan 2020'},
  ];

  ExpandableBottomSheet _buildExpandableBottomSheet() => ExpandableBottomSheet(
        controller: ExpandableBottomSheetController(),
        title: 'Deal Cancellation',
        hint:
            'Allows you to cancel your trade within a chosen time frame should the market move against your favour.',
        upperContent: const ChartSetting(),
        lowerContent: GroupedListView<dynamic, String>(
          groupBy: (dynamic element) => element['group'],
          groupSeparatorBuilder: (String value) => Container(
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
          separator: Container(
            color: const Color(0xFF0E0E0E),
            height: 1,
          ),
          elements: _elements,
          order: GroupedListOrder.descending,
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
        openMaximized: true,
      );

  ///
  Widget getListItems() => ExpandableListView(
        shrinkWrap: true,
        builder: SliverExpandableChildDelegate<Contract, ContractExpand>(
          sticky: false,
          sectionList: sectionList,
          headerBuilder: _buildHeader,
          itemBuilder: (
            BuildContext context,
            int sectionIndex,
            int itemIndex,
            int index,
          ) =>
              PositionItem(
                  contract: sectionList[sectionIndex].items[itemIndex]),
          separatorBuilder: (
            BuildContext context,
            bool isSectionSeparator,
            int index,
          ) =>
              Container(color: const Color(0xFF0E0E0E), height: 1),
        ),
      );

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 52,
          width: double.infinity,
          color: const Color(0xFF0E0E0E),
          padding: const EdgeInsets.only(left: 16, top: 24),
          child: Text(
            sectionList[sectionIndex].header,
            style: const TextStyle(
              color: Color(0xFFC2C2C2),
              fontSize: 14,
            ),
          ),
        ),
        onTap: () {
          final ContractExpand section = sectionList[sectionIndex];

          setState(() {
            section.setSectionExpanded(!section.isSectionExpanded());
          });
        },
      );
}

///
class ContractExpand implements ExpandableListSection<Contract> {
  ///
  ContractExpand(this.header, this.items);

  ///
  final List<Contract> items;

  ///
  final String header;

  ///
  bool expanded;

  @override
  List<Contract> getItems() => items;

  @override
  bool isSectionExpanded() => expanded;

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}

///
class MockData {
  ///return a example list, by default, we have 10 sections,
  ///each section has 5 items.
  static List<ContractExpand> getExampleSections([
    int sectionSize = 10,
    int itemSize = 5,
  ]) {
    final List<ContractExpand> sections = <ContractExpand>[];

    for (int i = 0; i < sectionSize; i++) {
      final ContractExpand section = ContractExpand(
        '0${i + 1} Jan 2020',
        List<Contract>.generate(
          itemSize,
          (int index) => Contract(),
        ),
      )..expanded = true;

      sections.add(section);
    }

    return sections;
  }
}
