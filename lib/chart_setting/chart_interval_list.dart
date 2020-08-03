part of 'chart_setting.dart';

class _ChartIntervalList extends StatelessWidget {
  const _ChartIntervalList({
    @required this.items,
    @required this.selectedChartInterval,
    @required this.scrollController,
    Key key,
    this.onSelectChartInterval,
  }) : super(key: key);

  final List<_ChartInterval> items;
  final ChartInterval selectedChartInterval;

  final ScrollController scrollController;

  final OnSelectChartIntervalCallback onSelectChartInterval;

  static const double _itemWidth = 76;
  static const double _itemHight = 48;

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
              child: _ChartIntervalButton(
                chartInterval: items[index],
                isSelected: selectedChartInterval == items[index].interval,
                onSelect: onSelectChartInterval,
              ),
            ),
          ),
        ),
      );

  static void moveToSelectedItem({
    @required List<_ChartInterval> items,
    @required ScrollController scrollController,
    @required bool Function(_ChartInterval) predicate,
  }) =>
      scrollController.jumpTo(
        items.indexOf(items
                    .firstWhere((_ChartInterval item) => predicate(item))) *
                (_itemWidth + _spaceBetweenItems) -
            _spaceBetweenItems,
      );
}
