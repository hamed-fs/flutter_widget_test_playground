import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';

part 'expandable_bottom_sheet_controller.dart';
part 'expandable_bottom_sheet_lower_content.dart';
part 'expandable_bottom_sheet_provider.dart';
part 'expandable_bottom_sheet_title_bar.dart';
part 'expandable_bottom_sheet_upper_content.dart';

/// Expandable bottom sheet widget
class ExpandableBottomSheet extends StatefulWidget {
  /// Initializes
  const ExpandableBottomSheet({
    Key key,
    this.upperContent,
    this.lowerContent,
    this.title,
    this.hint,
    this.maxHeight,
    this.openMaximized = false,
    this.changeStateDuration = const Duration(milliseconds: 150),
    this.onOpen,
    this.onClose,
    this.onToggle,
    this.onDismiss,
  }) : super(key: key);

  /// Upper content widget
  /// This part will be shown in close and open state
  final Widget upperContent;

  /// Lower content widget
  /// This part will be shown in open state
  final Widget lowerContent;

  /// Expandable bottom sheet title
  /// Title part will be invisible if [title] not set
  final String title;

  /// Expandable bottom sheet hint
  /// Hint button will be invisible if [hint] or [title] not set
  final String hint;

  /// Sets maximum height for expandable bottom sheet
  /// Expandable bottom sheet will be full screen if [maxHeight] not set
  final double maxHeight;

  /// Opens expandable bottom sheet in maximized state
  final bool openMaximized;

  /// Change state animation duration
  final Duration changeStateDuration;

  /// [onOpen] callback
  /// This callback will be called when expandable bottom sheet is open
  final VoidCallback onOpen;

  /// [onClose] callback
  /// This callback will be called when expandable bottom sheet is close
  final VoidCallback onClose;

  /// [onToggle] callback
  /// This callback will be called when toggle expandable bottom sheet
  final VoidCallback onToggle;

  /// [onDismiss] callback
  /// This callback will be called on expandable bottom sheet dismiss
  final VoidCallback onDismiss;

  @override
  _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  bool _isDragDirectionUp = false;
  double _upperContentHeight;

  final _ExpandableBottomSheetController _controller =
      _ExpandableBottomSheetController();

  final ThemeProvider _themeProvider = ThemeProvider();

  static const double _togglerHeight = 44;

  @override
  void initState() {
    super.initState();

    if (widget.lowerContent != null && widget.openMaximized) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => Future<void>.delayed(const Duration(), open),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller.isOpen()
        ? open(withCallback: false)
        : close(withCallback: false);
  }

  @override
  Widget build(BuildContext context) => _ExpandableBottomSheetProvider(
        controller: _controller,
        upperContent: widget.upperContent,
        lowerContent: widget.lowerContent,
        title: widget.title,
        hint: widget.hint,
        changeStateDuration: widget.changeStateDuration,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: _themeProvider.base07Color,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              _ExpandableBottomSheetTitleBar(
                onVerticalDragEnd: _onVerticalDragEnd,
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onTogglerTap: _onTogglerTap,
              ),
              _ExpandableBottomSheetUpperContent(
                onHeightCalculated: (double height) =>
                    _upperContentHeight = height,
              ),
              widget.lowerContent == null
                  ? Container()
                  : const _ExpandableBottomSheetLowerContent(),
            ],
          ),
        ),
      );

  void _onVerticalDragUpdate(DragUpdateDetails data) {
    if (_controller.height - data.delta.dy > 0 &&
        _controller.height - data.delta.dy < _getAvailableHeight()) {
      _isDragDirectionUp = data.delta.dy <= 0;
      _controller.height -= data.delta.dy;
    }
  }

  void _onVerticalDragEnd(DragEndDetails data) {
    if (!_isDragDirectionUp && !_controller.isOpen()) {
      close(dismiss: !_controller.isOpen());
    } else {
      widget.lowerContent != null && _isDragDirectionUp ? open() : close();
    }
  }

  void _onTogglerTap() {
    widget.onToggle?.call();

    _controller.isOpen() ? close() : open();
  }

  void open({bool withCallback = true}) {
    if (withCallback) {
      widget.onOpen?.call();

      _closeHintBubble();
    }

    _controller.height = _getAvailableHeight();
  }

  void close({
    bool withCallback = true,
    bool dismiss = false,
  }) {
    if (withCallback) {
      dismiss ? widget.onDismiss?.call() : widget.onClose?.call();

      _closeHintBubble();
    }

    _controller.height = 0;

    if (dismiss) {
      Navigator.pop(context);
    }
  }

  void _closeHintBubble() {
    if (_controller.isHintOpen) {
      _controller.isHintOpen = false;
    }
  }

  double _getAppBarHeight() => Scaffold.of(context).appBarMaxHeight ?? 0.0;

  double _getTitleHeight() =>
      _togglerHeight + (widget.title == null ? 0.0 : 48.0);

  double _getDeviceHeight() => MediaQuery.of(context).size.height;

  double _getAvailableHeight() {
    final double availableHeight =
        _getDeviceHeight() - _getAppBarHeight() - _getTitleHeight();

    return (widget.maxHeight == null
            ? availableHeight
            : min(widget.maxHeight, availableHeight)) -
        _upperContentHeight;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
