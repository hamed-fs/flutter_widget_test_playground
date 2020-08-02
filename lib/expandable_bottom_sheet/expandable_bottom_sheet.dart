import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet/expandable_bottom_sheet_controller.dart';

part 'expandable_bottom_sheet_lower_content.dart';
part 'expandable_bottom_sheet_title_bar.dart';
part 'expandable_bottom_sheet_upper_content.dart';
part 'expandable_bottom_sheet_provider.dart';

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

  static const double _togglerHeight = 44;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.controller.height = 0;
    widget.controller.value = false;

    widget.controller
        .addListener(() => widget.controller.value ? open() : close());

    if (widget.lowerContent != null && widget.openMaximized) {
      SchedulerBinding.instance.addPostFrameCallback(
          (_) => Future<void>.delayed(const Duration(), _onTogglerTap));
    }
  }

  @override
  Widget build(BuildContext context) => _ExpandableBottomSheetProvider(
        controller: widget.controller,
        upperContent: widget.upperContent,
        lowerContent: widget.lowerContent,
        title: widget.title,
        hint: widget.hint,
        maxHeight: widget.maxHeight,
        openMaximized: widget.openMaximized,
        changeStateDuration: widget.changeStateDuration,
        onOpen: widget.onOpen,
        onClose: widget.onClose,
        onToggle: widget.onToggle,
        onDismiss: widget.onDismiss,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: _themeProvider.base07Color,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              if (widget.lowerContent != null)
                const _ExpandableBottomSheetLowerContent(),
            ],
          ),
        ),
      );

  void _onTogglerTap() {
    widget.onToggle?.call();

    widget.controller.value = widget.controller.height != _maxHeight;

    setState(() => _hintIsVisible = false);
  }

  void _onVerticalDragUpdate(DragUpdateDetails data) {
    if (widget.controller.height - data.delta.dy > 0 &&
        widget.controller.height - data.delta.dy < _maxHeight) {
      _isDragDirectionUp = data.delta.dy <= 0;
      widget.controller.height -= data.delta.dy;

      setState(() => _hintIsVisible = false);
    }
  }

  void _onVerticalDragEnd(DragEndDetails data) {
    if (_isDragDirectionUp && widget.controller.value) {
      open();
    } else if (!(_isDragDirectionUp || widget.controller.value)) {
      close();

      if (widget.controller.height == 0) {
        dismiss();
      }
    } else {
      widget.controller.value =
          widget.lowerContent != null && _isDragDirectionUp;
    }
  }

  void open() {
    widget.onOpen?.call();

    widget.controller.height = _maxHeight;
  }

  void close() {
    widget.onClose?.call();

    widget.controller.height = 0;
  }

  void dismiss() {
    widget.onDismiss?.call();

    widget.controller.height = 0;

    Navigator.pop(context);
  }

  double _getAppBarHeight() => Scaffold.of(context).appBarMaxHeight ?? 0.0;

  double _getTitleHeight() =>
      _togglerHeight + (widget.title == null ? 0.0 : 48.0);

  double _getDeviceHeight() => MediaQuery.of(context).size.height;

  double _getAvailableHeight() =>
      _getDeviceHeight() - _getAppBarHeight() - _getTitleHeight();
}
