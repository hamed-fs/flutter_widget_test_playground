import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/chart_setting.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet.dart';
import 'package:flutter_widget_test_playground/position_item.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

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
      lowerContent: getListItems(),
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
    );

///
Widget getListItems() {
  final List<ContractExpand> sectionList = MockData.getExampleSections();
  return ExpandableListView(
    shrinkWrap: true,
    builder: SliverExpandableChildDelegate<Contract, ContractExpand>(
      sectionList: sectionList,
      headerBuilder: (BuildContext context, int sectionIndex, int index) =>
          Container(
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
      itemBuilder: (
        BuildContext context,
        int sectionIndex,
        int itemIndex,
        int index,
      ) =>
          PositionItem(contract: sectionList[sectionIndex].items[itemIndex]),
      separatorBuilder: (
        BuildContext context,
        bool isSectionSeparator,
        int index,
      ) =>
          Container(color: const Color(0xFF0E0E0E), height: 1),
    ),
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

  bool _expanded;

  @override
  List<Contract> getItems() => items;

  @override
  bool isSectionExpanded() => _expanded;

  @override
  void setSectionExpanded(bool expanded) {
    _expanded = expanded;
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
        '0$i Jan 2020',
        List<Contract>.generate(
          itemSize,
          (int index) => Contract(),
        ),
      ).._expanded = true;

      sections.add(section);
    }

    return sections;
  }
}
