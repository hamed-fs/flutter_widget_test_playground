import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// The signature for a function that's called when the user has dragged list
typedef RefreshHandler = Future<void> Function();

/// Grouped list view
class GroupedListView<E, G extends Comparable<Object>> extends StatefulWidget {
  /// initializes
  const GroupedListView({
    @required this.itemBuilder,
    Key key,
    this.elements,
    this.groupBy,
    this.groupBuilder,
    this.separator,
    this.controller,
    this.sort = true,
    this.enableStickyHeader = false,
    this.hasRefreshIndicator = false,
    this.refreshIndicatorDisplacement = 40,
    this.onRefresh,
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

  /// Function which returns an widget which defines the item
  final Widget Function(BuildContext context, E element) itemBuilder;

  /// Items of which [itemBuilder] produce the list
  final List<E> elements;

  /// Function which maps an element to its grouped value
  final G Function(E element) groupBy;

  /// Function which gets the group by value and returns an widget which defines the group header separator
  final Widget Function(G group) groupBuilder;

  /// Builds separators for between each item in the list
  final Widget separator;

  /// An object that can be used to control the position to which this scroll view is scrolled
  final ScrollController controller;

  /// Sets the elements should sort or not
  final bool sort;

  /// Enables sticky header
  final bool enableStickyHeader;

  /// Sets refresh indicator
  final bool hasRefreshIndicator;

  /// Sets refresh indicator displacement
  final double refreshIndicatorDisplacement;

  /// On refresh handler
  final RefreshHandler onRefresh;

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
  int _currentGroup = 0;

  ScrollController _scrollController;

  BuildContext _groupContext;
  BuildContext _itemContext;
  BuildContext _separatorContext;

  double _groupHeight;
  double _itemHeight;
  double _separatorHeight;

  @override
  void initState() {
    super.initState();

    _scrollController = widget.controller ?? ScrollController();

    if (_hasStickyHeader()) {
      _scrollController.addListener(_scrollControllerListener);
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _groupHeight ??= _groupContext?.size?.height ?? 0;
      _itemHeight ??= _itemContext?.size?.height ?? 0;
      _separatorHeight ??= _separatorContext?.size?.height ?? 0;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _sortList(widget.elements);

    return Stack(
      children: <Widget>[
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();

            return false;
          },
          child: widget.hasRefreshIndicator && widget.onRefresh != null
              ? RefreshIndicator(
                  displacement: widget.refreshIndicatorDisplacement,
                  child: _buildListView(),
                  onRefresh: widget.onRefresh,
                )
              : _buildListView(),
        ),
        if (_hasStickyHeader())
          widget.groupBuilder(_getGroupNames()[_currentGroup]),
      ],
    );
  }

  Widget _buildListView() => ListView.builder(
        scrollDirection: widget.scrollDirection,
        controller: _scrollController,
        primary: widget.primary,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding,
        itemCount: widget.elements.length * (_hasGroup() ? 2 : 1),
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
        cacheExtent: widget.cacheExtent,
        itemBuilder: (BuildContext context, int index) {
          final int actualIndex = index ~/ (_hasGroup() ? 2 : 1);

          if (_hasGroup() && index.isEven) {
            final G currentGroup = widget.groupBy(widget.elements[actualIndex]);
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
                  context,
                  widget.elements[actualIndex],
                );
              }),
              if (widget.separator != null)
                Builder(builder: (BuildContext context) {
                  _separatorContext ??= context;

                  return widget.separator;
                }),
            ],
          );
        },
      );

  void _sortList(List<E> list) {
    if (!widget.sort ||
        !_hasGroup() ||
        widget.elements == null ||
        widget.elements.isEmpty) {
      return;
    }

    list.sort(
      (E firstElement, E secondElement) =>
          (widget.groupBy(firstElement)).compareTo(
        widget.groupBy(secondElement),
      ),
    );
  }

  List<G> _getGroupNames() => groupBy<E, G>(widget.elements, widget.groupBy)
      .entries
      .map<G>((dynamic entry) => entry.key)
      .toList();

  void _scrollControllerListener() {
    final List<double> groupHeights = _getGroupHeights();
    final double controllerOffset = _scrollController.offset + _groupHeight;

    if (controllerOffset < groupHeights.first) {
      if (_currentGroup != 0) {
        setState(() => _currentGroup = 0);
      }
    } else {
      for (int i = 1; i < groupHeights.length; i++) {
        if (controllerOffset >= groupHeights[i - 1] &&
            controllerOffset < groupHeights[i]) {
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

  bool _hasGroup() => widget.groupBy != null && widget.groupBuilder != null;

  bool _hasStickyHeader() => _hasGroup() && widget.enableStickyHeader;
}
