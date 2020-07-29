import 'package:flutter/material.dart';

/// Grouped list view
class GroupedListView<T, E extends Comparable<Object>> extends StatefulWidget {
  /// Initializes
  const GroupedListView({
    @required this.groupBy,
    @required this.groupSeparatorBuilder,
    @required this.itemBuilder,
    Key key,
    this.order = GroupedListOrder.ascending,
    this.sort = true,
    this.separator = const Divider(),
    this.elements,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
  }) : super(key: key);

  /// Function which maps an element to its grouped value
  final E Function(T element) groupBy;

  /// Function which gets the group by value and returns an widget which defines the group header separator
  final Widget Function(E value) groupSeparatorBuilder;

  /// Function which returns an widget which defines the item
  final Widget Function(BuildContext context, T element) itemBuilder;

  /// Changes grouped list order
  final GroupedListOrder order;

  /// Sets the elements should sort or not
  final bool sort;

  /// Builds separators for between each item in the list
  final Widget separator;

  /// Items of which [itemBuilder] produce the list
  final List<T> elements;

  /// Sets the axis along which the scroll view scrolls
  final Axis scrollDirection;

  /// An object that can be used to control the position to which this scroll view is scrolled
  final ScrollController controller;

  /// Whether this is the primary scroll view associated with the parent
  final bool primary;

  /// Sets how the scroll view should respond to user input
  final ScrollPhysics physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be determined by the contents being viewed
  final bool shrinkWrap;

  /// The amount of space by which to inset the children
  final EdgeInsetsGeometry padding;

  /// Whether to wrap each child in an [AutomaticKeepAlive]
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary]
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics]
  final bool addSemanticIndexes;

  /// See [SliverChildBuilderDelegate.addSemanticIndexes]
  final double cacheExtent;

  @override
  _GroupedListViewState<T, E> createState() => _GroupedListViewState<T, E>();
}

class _GroupedListViewState<T, E extends Comparable<Object>>
    extends State<GroupedListView<T, E>> {
  List<T> _elements;

  @override
  void initState() {
    super.initState();

    _elements = widget.elements;

    if (widget.sort && _elements != null && _elements.isNotEmpty) {
      _elements.sort((T firstElement, T secondElement) =>
          (widget.groupBy(firstElement))
              .compareTo(widget.groupBy(secondElement)));

      if (widget.order == GroupedListOrder.descending) {
        _elements = _elements.reversed.toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListView.separated(
        key: widget.key,
        scrollDirection: widget.scrollDirection,
        controller: widget.controller,
        primary: widget.primary,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding,
        itemCount: _elements.length * 2,
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
        cacheExtent: widget.cacheExtent,
        separatorBuilder: (BuildContext context, int index) => widget.separator,
        itemBuilder: (BuildContext context, int index) {
          final int actualIndex = index ~/ 2;

          if (index.isEven) {
            final E currentGroup = widget.groupBy(_elements[actualIndex]);
            final E previousGroup = actualIndex - 1 < 0
                ? null
                : widget.groupBy(_elements[actualIndex - 1]);

            if (previousGroup != currentGroup) {
              return widget.groupSeparatorBuilder(currentGroup);
            }

            return Container();
          }

          return widget.itemBuilder(context, _elements[actualIndex]);
        },
      );
}

/// Grouped list order enum
enum GroupedListOrder {
  /// Ascending order
  ascending,

  /// descending order
  descending,
}
