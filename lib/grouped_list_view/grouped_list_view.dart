import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'grouped_list_view_order.dart';

part 'grouped_list_view_controller.dart';

/// A function that's called when the user has dragged the refresh indicator
/// far enough to demonstrate that they want the app to refresh. The returned
/// [Future] must complete when the refresh operation is finished.
typedef RefreshHandler = Future<void> Function();

/// Grouped list view widget
class GroupedListView<E, G extends Comparable<Object>> extends StatefulWidget {
  /// Grouped list view
  ///
  /// If you set [groupBy] and [groupBuilder] properties, the list items will be grouped by the provided grouping information.
  /// [hasStickyHeader] will keep your header in top of the list
  /// Also pull to refresh is applicable by setting [hasRefreshIndicator] to `true`
  /// and providing [onRefresh] handler.
  const GroupedListView({
    @required this.itemBuilder,
    Key key,
    this.elements,
    this.groupBy,
    this.groupBuilder,
    this.separator,
    this.controller,
    this.sort = true,
    this.order = GroupedListViewOrder.ascending,
    this.hasStickyHeader = false,
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

  /// Item builder generates widget for each element in [elements] list
  final Widget Function(BuildContext context, E element) itemBuilder;

  /// Elements to produce the list with [itemBuilder]
  final List<E> elements;

  /// Function which maps an element to its grouped value
  final G Function(E element) groupBy;

  /// Function which gets the group by value and returns a widget
  final Widget Function(G group) groupBuilder;

  /// Separator widget for each item in the list
  final Widget separator;

  /// An object that can be used to control the scroll position
  final ScrollController controller;

  /// To determine if the elements should be sorted or not
  ///
  /// This defaults to `true`
  final bool sort;

  /// Changes grouped list order
  ///
  /// This defaults to [GroupedListViewOrder.ascending]
  final GroupedListViewOrder order;

  /// Enables sticky header
  ///
  /// Sticky header is disabled by default
  final bool hasStickyHeader;

  /// Enables refresh indicator
  ///
  /// Refreshing indicator is disabled by default
  final bool hasRefreshIndicator;

  /// Sets refresh indicator displacement
  ///
  /// This defaults to `40`
  final double refreshIndicatorDisplacement;

  /// On refresh handler
  final RefreshHandler onRefresh;

  /// Sets the axis along which the scroll view scrolls
  ///
  /// This defaults to [Axis.vertical]
  final Axis scrollDirection;

  /// Whether this is the primary scroll view associated with the parent
  final bool primary;

  /// Sets how the scroll view should respond to user input
  final ScrollPhysics physics;

  /// The amount of space by which to inset the children
  final EdgeInsetsGeometry padding;

  /// Whether the extent of the scroll view in the [scrollDirection] should be determined by the contents being viewed
  ///
  /// This defaults to `false`
  final bool shrinkWrap;

  /// Whether to wrap each child in an [AutomaticKeepAlive]
  ///
  /// [AutomaticKeepAlive] allows subtrees to request to be kept alive in lazy lists.
  /// This defaults to `true`
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary]
  ///
  /// This defaults to `true`
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics]
  ///
  /// This defaults to `true`
  final bool addSemanticIndexes;

  /// See [SliverChildBuilderDelegate.addSemanticIndexes] for more information
  final double cacheExtent;

  @override
  _GroupedListViewState<E, G> createState() => _GroupedListViewState<E, G>();
}

class _GroupedListViewState<E, G extends Comparable<Object>>
    extends State<GroupedListView<E, G>> {
  List<E> _elements;

  BuildContext _groupContext;
  BuildContext _itemContext;
  BuildContext _separatorContext;

  double _groupHeight;
  double _itemHeight;
  double _separatorHeight;

  ScrollController _scrollController;

  final _GroupedListViewController _groupedListViewController =
      _GroupedListViewController();

  @override
  void initState() {
    super.initState();

    _elements = widget.elements;
    _scrollController = widget.controller ?? ScrollController();

    if (_hasStickyHeader()) {
      _scrollController.addListener(_scrollControllerListener);
    }

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _initializeItemHeights());
  }

  @override
  Widget build(BuildContext context) {
    _sortList(_elements);

    return _hasRefreshIndicator()
        ? RefreshIndicator(
            displacement: widget.refreshIndicatorDisplacement,
            child: _buildMainContent(),
            onRefresh: widget.onRefresh,
          )
        : _buildMainContent();
  }

  Widget _buildMainContent() => Stack(
        children: <Widget>[
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();

              return false;
            },
            child: _buildListView(),
          ),
          if (_hasStickyHeader())
            StreamBuilder<int>(
              initialData: 0,
              stream: _groupedListViewController.stream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
                  widget.groupBuilder(_getGroupNames()[snapshot.data]),
            )
        ],
      );

  Widget _buildListView() => ListView.builder(
        scrollDirection: widget.scrollDirection,
        controller: _scrollController,
        primary: widget.primary,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding,
        itemCount: _getItemCount(),
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
        cacheExtent: widget.cacheExtent,
        itemBuilder: (BuildContext context, int index) {
          final int actualIndex = getItemIndex(index);

          if (_hasGroup() && index.isEven) {
            final G currentGroup = widget.groupBy(_elements[actualIndex]);
            final G previousGroup = actualIndex - 1 < 0
                ? null
                : widget.groupBy(_elements[actualIndex - 1]);

            return Builder(builder: (BuildContext context) {
              if (previousGroup != currentGroup) {
                _groupContext ??= context;

                return widget.groupBuilder(currentGroup);
              }

              return const SizedBox.shrink();
            });
          }

          return Column(
            children: <Widget>[
              Builder(builder: (BuildContext context) {
                _itemContext ??= context;

                return widget.itemBuilder(
                  context,
                  _elements[actualIndex],
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
        _elements == null ||
        _elements.isEmpty) {
      return;
    }

    list.sort(
      (E firstElement, E secondElement) =>
          (widget.groupBy(firstElement)).compareTo(
        widget.groupBy(secondElement),
      ),
    );

    if (widget.order == GroupedListViewOrder.descending) {
      _elements = list.reversed.toList();
    }
  }

  List<G> _getGroupNames() => groupBy<E, G>(_elements, widget.groupBy)
      .entries
      .map<G>((dynamic entry) => entry.key)
      .toList();

  void _initializeItemHeights() {
    _groupHeight ??= _groupContext?.size?.height ?? 0;
    _itemHeight ??= _itemContext?.size?.height ?? 0;
    _separatorHeight ??= _separatorContext?.size?.height ?? 0;
  }

  List<double> _getGroupHeights() {
    double sum = 0;

    final List<double> groupHeights = groupBy<E, G>(_elements, widget.groupBy)
        .entries
        .map<double>((dynamic entry) => entry.value.length.toDouble())
        .toList();

    return groupHeights
        .map<double>((double itemCount) =>
            sum += itemCount * (_itemHeight + _separatorHeight) + _groupHeight)
        .toList();
  }

  // First, we should get each item group height by calling _getGroupHeights() method,
  // Then by checking list view controller offset we can indicate the current list group
  // and set currentGroupIndex for showing corresponding sticky header.
  void _scrollControllerListener() {
    final List<double> groupHeights = _getGroupHeights();
    final double controllerOffset = _scrollController.offset + _groupHeight;

    if (controllerOffset < groupHeights.first) {
      _changeCurrentGroupIndex(0);
    } else {
      for (int i = 1; i < groupHeights.length; i++) {
        if (controllerOffset >= groupHeights[i - 1] &&
            controllerOffset < groupHeights[i]) {
          _changeCurrentGroupIndex(i);

          break;
        }
      }
    }
  }

  void _changeCurrentGroupIndex(int i) {
    if (_groupedListViewController.currentGroupIndex != i) {
      _groupedListViewController.currentGroupIndex = i;
    }
  }

  int _getItemCount() => (_elements?.length ?? 0) * (_hasGroup() ? 2 : 1);

  int getItemIndex(int index) => index ~/ (_hasGroup() ? 2 : 1);

  bool _hasGroup() => widget.groupBy != null && widget.groupBuilder != null;

  bool _hasStickyHeader() => _hasGroup() && widget.hasStickyHeader;

  bool _hasRefreshIndicator() =>
      widget.hasRefreshIndicator && widget.onRefresh != null;

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollControllerListener);
    _scrollController?.dispose();

    _groupedListViewController?.dispose();

    super.dispose();
  }
}
