part of 'chart_setting.dart';

class _ChartSettingItemList<T, U, V> extends StatelessWidget {
  const _ChartSettingItemList({
    @required this.itemBuilder,
    @required this.items,
    @required this.scrollController,
    @required this.selectedType,
    @required this.itemWidth,
    @required this.itemHight,
    @required this.spaceBetweenItems,
    Key key,
    this.onSelect,
  }) : super(key: key);

  final Widget Function(T item, U selectedType, V onSelect) itemBuilder;
  final List<T> items;
  final ScrollController scrollController;
  final U selectedType;
  final double itemWidth;
  final double itemHight;
  final double spaceBetweenItems;
  final V onSelect;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: itemHight,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return false;
            },
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              shrinkWrap: true,
              controller: scrollController,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(width: spaceBetweenItems),
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: itemWidth,
                height: itemHight,
                child: itemBuilder(
                  items[index],
                  selectedType,
                  onSelect,
                ),
              ),
            ),
          ),
        ),
      );

  static void moveToSelectedItem<T>({
    @required List<T> items,
    @required ScrollController scrollController,
    @required double itemWidth,
    @required double spaceBetweenItems,
    @required bool Function(T) predicate,
  }) =>
      scrollController.jumpTo(
        items.indexOf(items.firstWhere((T item) => predicate(item))) *
                (itemWidth + spaceBetweenItems) -
            spaceBetweenItems,
      );
}
