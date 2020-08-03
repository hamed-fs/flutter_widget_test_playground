part of 'chart_setting.dart';

class _ChartTypeList extends StatelessWidget {
  const _ChartTypeList({
    @required this.items,
    @required this.selectedChartType,
    @required this.scrollController,
    Key key,
    this.onSelectChartType,
  }) : super(key: key);

  final List<_ChartType> items;
  final ChartType selectedChartType;

  final ScrollController scrollController;

  final OnSelectChartTypeCallback onSelectChartType;

  static const double _itemWidth = 160;
  static const double _itemHight = 80;

  static const double _spaceBetweenItems = 8;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: _itemHight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: _spaceBetweenItems),
            itemBuilder: (BuildContext context, int index) => SizedBox(
              width: _itemWidth,
              height: _itemHight,
              child: _ChartTypeButton(
                chartType: items[index],
                isSelected: selectedChartType == items[index].chartType,
                onSelect: onSelectChartType,
              ),
            ),
          ),
        ),
      );

  static void moveToSelectedItem({
    @required List<_ChartType> items,
    @required ScrollController scrollController,
    @required bool Function(_ChartType) predicate,
  }) {
    if (items.length > 2) {
      scrollController.jumpTo(
        items.indexOf(items.firstWhere((_ChartType item) => predicate(item))) *
                (_itemWidth + _spaceBetweenItems) -
            _spaceBetweenItems,
      );
    }
  }
}
