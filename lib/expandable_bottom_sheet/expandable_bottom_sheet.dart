import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';

part 'expandable_bottom_sheet_lower_content.dart';
part 'expandable_bottom_sheet_title_bar.dart';
part 'expandable_bottom_sheet_upper_content.dart';

/// Expandable bottom sheet callback
typedef ExpandableBottomSheetCallback = void Function();

/// Expandable bottom sheet widget
class ExpandableBottomSheet extends StatefulWidget {
  /// Initializes
  const ExpandableBottomSheet({
    @required this.controller,
    Key key,
    this.toggler,
    this.upperContent,
    this.lowerContent,
    this.title,
    this.hint,
    this.maxHeight,
    this.openMaximized = false,
    this.changeStateDuration,
    this.onOpen,
    this.onClose,
    this.onDismiss,
  }) : super(key: key);

  /// Expandable bottom sheet controller
  final ExpandableBottomSheetController controller;

  /// Toggler widget
  /// Shows default toggler widget if [toggler] not set
  final Widget toggler;

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
  final ExpandableBottomSheetCallback onOpen;

  /// [onClose] callback
  /// This callback will be called when expandable bottom sheet is close
  final ExpandableBottomSheetCallback onClose;

  /// [onDismiss] callback
  /// This callback will be called on expandable bottom sheet dismiss
  final ExpandableBottomSheetCallback onDismiss;

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
  Widget build(BuildContext context) => Container(
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
              title: widget.title,
              hint: widget.hint,
              toggler: widget.toggler,
              isVisible: _hintIsVisible,
              isOpen: widget.controller.isOpened,
              onVerticalDragEnd: _onVerticalDragEnd,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onTogglerTap: _onTogglerTap,
              onHintTap: () => setState(() => _hintIsVisible = !_hintIsVisible),
            ),
            _ExpandableBottomSheetUpperContent(
              content: widget.upperContent,
              onHeightCalculated: (double value) => _maxHeight =
                  (widget.maxHeight ?? _getAvailableHeight()) - value,
            ),
            if (widget.lowerContent != null)
              _ExpandableBottomSheetLowerContent(
                content: widget.lowerContent,
                controller: widget.controller,
              ),
          ],
        ),
      );

  void _onTogglerTap() {
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
      widget.controller.value = _isDragDirectionUp;
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

/// Expandable bottom sheet controller
class ExpandableBottomSheetController extends ValueNotifier<bool> {
  /// Initializes
  ExpandableBottomSheetController() : super(false);

  final ExpandableBottomSheetBloc _expandableBottomSheetBloc =
      ExpandableBottomSheetBloc();

  double _height;

  /// Gets height
  double get height => _height;

  /// Sets hight
  set height(double value) =>
      _expandableBottomSheetBloc.dispatch(_height = value);

  /// Gets hight stream
  Stream<double> get heightStream => _expandableBottomSheetBloc.height;

  /// Gets open or close state stream
  Stream<bool> get isOpenStream => _expandableBottomSheetBloc.isOpen;

  /// Gets open or close state
  bool get isOpened => value;

  /// Closes bottom sheet
  void close() => value = false;

  /// Opens bottom sheet
  void open() => value = true;

  @override
  void dispose() {
    _expandableBottomSheetBloc.dispose();

    super.dispose();
  }
}

/// Expandable bottom sheet bloc
class ExpandableBottomSheetBloc {
  final StreamController<double> _heightController =
      StreamController<double>.broadcast();
  final StreamController<bool> _visibilityController =
      StreamController<bool>.broadcast();

  /// Gets hight
  Stream<double> get height => _heightController.stream;

  /// Gets open or close state
  Stream<bool> get isOpen => _visibilityController.stream;

  /// Adds values to controller
  void dispatch(double value) {
    _heightController.sink.add(value);
    _visibilityController.sink.add(value > 0);
  }

  /// Dispose controllers
  void dispose() {
    _heightController.close();
    _visibilityController.close();
  }
}
