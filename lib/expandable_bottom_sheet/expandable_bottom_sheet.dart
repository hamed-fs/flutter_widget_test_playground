import 'dart:async';
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
    @required this.controller,
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

  /// Expandable bottom sheet controller
  final ExpandableBottomSheetController controller;

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
  final ThemeProvider _themeProvider = ThemeProvider();

  bool _isDragDirectionUp = false;
  bool _hintIsVisible = false;
  double _maxHeight;

  ExpandableBottomSheetController _controller;

  static const double _togglerHeight = 44;

  @override
  void initState() {
    super.initState();

    if (_controller == null) {
      _controller = widget.controller;

      _controller
        ..height = 0
        ..isOpen = false
        ..addListener(() => _controller.height == 0 ? open() : close());
    }

    if (widget.lowerContent != null && widget.openMaximized) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => Future<void>.delayed(const Duration(), _onTogglerTap),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller.isOpen) {
      _controller.close();
    }
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
                isVisible: _hintIsVisible,
                onVerticalDragEnd: _onVerticalDragEnd,
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onTogglerTap: _onTogglerTap,
                onHintTap: () =>
                    setState(() => _hintIsVisible = !_hintIsVisible),
              ),
              _ExpandableBottomSheetUpperContent(
                onHeightCalculated: (double value) => _maxHeight =
                    (widget.maxHeight ?? _getAvailableHeight()) - value,
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
        _controller.height - data.delta.dy < _maxHeight) {
      _isDragDirectionUp = data.delta.dy <= 0;
      _controller.height -= data.delta.dy;
    }
  }

  void _onVerticalDragEnd(DragEndDetails data) {
    if (_isDragDirectionUp && _controller.isOpen) {
      open();
    } else if (!_isDragDirectionUp && !_controller.isOpen) {
      close(dismiss: _controller.height == 0);
    } else {
      _controller.isOpen = widget.lowerContent != null && _isDragDirectionUp;
    }
  }

  void _onTogglerTap() {
    widget.onToggle?.call();

    _closeHintBubble();

    _controller.isOpen = _controller.height != _maxHeight;
  }

  void open() {
    widget.onOpen?.call();

    _closeHintBubble();

    _controller.height = _maxHeight;
  }

  void close({bool dismiss = false}) {
    dismiss ? widget.onDismiss?.call() : widget.onClose?.call();

    _closeHintBubble();

    _controller.height = 0;

    if (dismiss) {
      Navigator.pop(context);
    }
  }

  void _closeHintBubble() {
    if (_hintIsVisible && mounted) {
      setState(() => _hintIsVisible = false);
    }
  }

  double _getAppBarHeight() => Scaffold.of(context).appBarMaxHeight ?? 0.0;

  double _getTitleHeight() =>
      _togglerHeight + (widget.title == null ? 0.0 : 48.0);

  double _getDeviceHeight() => MediaQuery.of(context).size.height;

  double _getAvailableHeight() =>
      _getDeviceHeight() - _getAppBarHeight() - _getTitleHeight();
}
