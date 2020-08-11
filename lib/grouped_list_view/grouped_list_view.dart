import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';

/// Grouped list view
class GroupedListView<E, G extends Comparable<Object>> extends StatefulWidget {
  /// initializes
  const GroupedListView({
    @required this.groupBy,
    @required this.groupBuilder,
    @required this.itemBuilder,
    Key key,
    this.elements,
    this.separator,
    this.controller,
    this.sort = true,
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

  /// Builds separators for between each item in the list
  final Widget separator;

  /// An object that can be used to control the position to which this scroll view is scrolled
  final ScrollController controller;

  /// Sets the elements should sort or not
  final bool sort;

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
  List<G> _groupNames;
  List<double> _groupHeights;
  int _currentGroup = 0;

  ScrollController _scrollController;

  BuildContext _groupContext;
  BuildContext _itemContext;
  BuildContext _separatorContext;

  double _groupHeight = 0;
  double _itemHeight = 0;
  double _separatorHeight = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = widget.controller ?? ScrollController();

    if (widget.sort && widget.elements != null && widget.elements.isNotEmpty) {
      _sortList(widget.elements);
    }

    _groupNames = _getGroupNames();

    _scrollController.addListener(_scrollControllerListener);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initialDimensions();
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: _groupHeight),
          ),
          ListView.builder(
            key: widget.key,
            scrollDirection: widget.scrollDirection,
            controller: _scrollController,
            primary: widget.primary,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            itemCount: widget.elements.length * 2,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
            cacheExtent: widget.cacheExtent,
            itemBuilder: (BuildContext context, int index) {
              final int actualIndex = index ~/ 2;

              if (index.isEven) {
                final G currentGroup =
                    widget.groupBy(widget.elements[actualIndex]);
                final G previousGroup = actualIndex - 1 < 0
                    ? null
                    : widget.groupBy(widget.elements[actualIndex - 1]);

                return Builder(builder: (BuildContext context) {
                  if (previousGroup != currentGroup) {
                    _groupContext ??= context;

                    return widget.groupBuilder(currentGroup);
                  }

                  return Container();
                });
              }

              return Column(
                children: <Widget>[
                  Builder(builder: (BuildContext context) {
                    _itemContext ??= context;

                    return widget.itemBuilder(
                        context, widget.elements[actualIndex]);
                  }),
                  if (widget.separator != null)
                    Builder(builder: (BuildContext context) {
                      _separatorContext ??= context;

                      return widget.separator;
                    }),
                ],
              );
            },
          ),
          if (widget.groupBuilder != null)
            widget.groupBuilder(_groupNames[_currentGroup]),
        ],
      );

  void _sortList(List<E> list) => list.sort(
        (E firstElement, E secondElement) =>
            (widget.groupBy(firstElement)).compareTo(
          widget.groupBy(secondElement),
        ),
      );

  void _initialDimensions() {
    _groupHeight = _groupContext?.size?.height ?? 0;
    _itemHeight = _itemContext?.size?.height ?? 0;
    _separatorHeight = _separatorContext?.size?.height ?? 0;

    _groupHeights = _getGroupHeights();

    setState(() {});
  }

  List<G> _getGroupNames() => groupBy<E, G>(widget.elements, widget.groupBy)
      .entries
      .map<G>((dynamic entry) => entry.key)
      .toList();

  void _scrollControllerListener() {
    final double controllerOffset = _scrollController.offset + _groupHeight;

    if (controllerOffset < _groupHeights.first) {
      if (_currentGroup != 0) {
        setState(() => _currentGroup = 0);
      }
    } else {
      for (int i = 1; i < _groupHeights.length; i++) {
        if (controllerOffset >= _groupHeights[i - 1] &&
            controllerOffset < _groupHeights[i]) {
          if (_currentGroup != i) {
            setState(() => _currentGroup = i);
          }

          break;
        }
      }
    }
  }

  List<double> _getGroupHeights() {
    double sum = 0;

    final List<double> groupHeights =
        groupBy<E, G>(widget.elements, widget.groupBy)
            .entries
            .map<double>((dynamic entry) => entry.value.length.toDouble())
            .toList();

    return groupHeights
        .map<double>((double itemCount) =>
            sum += itemCount * (_itemHeight + _separatorHeight) + _groupHeight)
        .toList();
  }
}
