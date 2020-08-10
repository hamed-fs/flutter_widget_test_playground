import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'grouped_list_order.dart';

/// Grouped list view
class GroupedListView<E, G extends Comparable<Object>> extends StatefulWidget {
  /// initializes
  const GroupedListView({
    @required this.groupBy,
    @required this.groupBuilder,
    @required this.itemBuilder,
    @required this.separatorHeight,
    @required this.tileHeight,
    Key key,
    this.elements,
    this.separator,
    this.controller,
    this.sort = true,
    this.order = GroupedListViewOrder.ascending,
    this.scrollDirection = Axis.vertical,
    this.primary,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
  }) : super(key: key);

  /// Function which maps an element to its grouped value
  final G Function(E element) groupBy;

  /// Function which gets the group by value and returns an widget which defines the group header separator
  final Widget Function(G group) groupBuilder;

  /// Function which returns an widget which defines the item
  final Widget Function(BuildContext context, E element) itemBuilder;

  /// Items of which [itemBuilder] produce the list
  final List<E> elements;

  /// Separator height
  final double separatorHeight;

  /// Tile height
  final double tileHeight;

  /// Builds separators for between each item in the list
  final Widget separator;

  /// An object that can be used to control the position to which this scroll view is scrolled
  final ScrollController controller;

  /// Sets the elements should sort or not
  final bool sort;

  /// Changes grouped list order
  final GroupedListViewOrder order;

  /// Sets the axis along which the scroll view scrolls
  final Axis scrollDirection;

  /// Whether this is the primary scroll view associated with the parent
  final bool primary;

  /// Sets how the scroll view should respond to user input
  final ScrollPhysics physics;

  /// The amount of space by which to inset the children
  final EdgeInsetsGeometry padding;

  /// Whether the extent of the scroll view in the [scrollDirection] should be determined by the contents being viewed
  final bool shrinkWrap;

  /// Whether to wrap each child in an [AutomaticKeepAlive]
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary]
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics]
  final bool addSemanticIndexes;

  /// See [SliverChildBuilderDelegate.addSemanticIndexes] for more information
  final double cacheExtent;

  @override
  _GroupedListViewState<E, G> createState() => _GroupedListViewState<E, G>();
}

class _GroupedListViewState<E, G extends Comparable<Object>>
    extends State<GroupedListView<E, G>> {
  List<E> _elements;

  List<double> _groupHeights;
  List<G> _groupNames;
  int _current = 0;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _elements = widget.elements;
    _scrollController = widget.controller ?? ScrollController();

    if (widget.sort && _elements != null && _elements.isNotEmpty) {
      _sortList(_elements);

      if (widget.order == GroupedListViewOrder.descending) {
        _elements = _elements.reversed.toList();
      }
    }

    _groupNames = groupBy<E, G>(_elements, (dynamic item) => item['group'])
        .entries
        .map<G>((dynamic entry) => entry.key)
        .toList();

    _groupHeights = groupBy<E, G>(_elements, (dynamic item) => item['group'])
        .entries
        .map<double>((dynamic entry) => entry.value.length.toDouble())
        .toList();

    double sum = 0;

    _groupHeights = _groupHeights
        .map<double>((double itemCount) =>
            sum += itemCount * widget.tileHeight + widget.separatorHeight)
        .toList();

    _scrollController.addListener(() {
      final double controllerOffset =
          _scrollController.offset + widget.separatorHeight;

      if (controllerOffset < _groupHeights[0]) {
        setState(() => _current = 0);
      } else {
        for (int i = 1; i < _groupHeights.length; i++) {
          if (controllerOffset >= _groupHeights[i - 1] &&
              controllerOffset < _groupHeights[i]) {
            setState(() => _current = i);

            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: widget.separatorHeight),
          ),
          ListView.builder(
            key: widget.key,
            scrollDirection: widget.scrollDirection,
            controller: _scrollController,
            primary: widget.primary,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            itemCount: _elements.length * 2,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
            cacheExtent: widget.cacheExtent,
            itemBuilder: (BuildContext context, int index) {
              final int actualIndex = index ~/ 2;

              if (index.isEven) {
                final G currentGroup = widget.groupBy(_elements[actualIndex]);
                final G previousGroup = actualIndex - 1 < 0
                    ? null
                    : widget.groupBy(_elements[actualIndex - 1]);

                if (previousGroup != currentGroup) {
                  return SizedBox(
                    height: widget.separatorHeight,
                    child: widget.groupBuilder(currentGroup),
                  );
                }

                return Container();
              }

              return SizedBox(
                height: widget.tileHeight,
                child: widget.itemBuilder(context, _elements[actualIndex]),
              );
            },
          ),
          SizedBox(
            height: widget.separatorHeight,
            child: widget.groupBuilder(_groupNames[_current]),
          ),
        ],
      );

  void _sortList(List<E> list) => list.sort(
        (E firstElement, E secondElement) =>
            (widget.groupBy(firstElement)).compareTo(
          widget.groupBy(secondElement),
        ),
      );
}
