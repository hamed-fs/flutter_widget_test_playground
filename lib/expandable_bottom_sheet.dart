import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';

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
    this.changeStateDuration = const Duration(milliseconds: 150),
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

  static const double _togglerHeight = 44;

  bool _isDragDirectionUp = false;
  bool _hintIsVisible = false;
  double _maxHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.controller.height = 0;
    widget.controller.value = false;

    widget.controller
        .addListener(() => widget.controller.value ? open() : close());

    if (widget.openMaximized) {
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
            _buildToggler(),
            if (widget.title != null) _buildTitleBar(),
            _buildUpperContent(),
            _buildLowerContent(),
          ],
        ),
      );

  Widget _buildToggler() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: widget.toggler ?? _buildDefaultToggler(),
        onTap: _onTogglerTap,
      );

  Container _buildDefaultToggler() => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 32,
        ),
        height: 4,
        width: 40,
        decoration: BoxDecoration(
          color: _themeProvider.base05Color,
          borderRadius: BorderRadius.circular(4),
        ),
      );

  Widget _buildTitleBar() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: <Widget>[
              if (widget.title != null) _buildTitle(),
              if (widget.hint != null)
                Positioned(
                  child: _buildHintButton(),
                  right: 18,
                ),
              if (widget.hint != null)
                Positioned(
                  child: _buildHintBubble(),
                  right: _getHintRightPosition(),
                  bottom: _getHintTopPosition(),
                ),
            ],
          ),
        ),
      );

  Widget _buildTitle() => Text(
        widget.title,
        style: _themeProvider.textStyle(
          textStyle: TextStyles.subheading,
          color: _themeProvider.base01Color,
        ),
      );

  Widget _buildHintButton() => ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: Icon(
              Icons.info_outline,
              size: 20,
              color: _themeProvider.base05Color,
            ),
            onTap: () => setState(() => _hintIsVisible = !_hintIsVisible),
          ),
        ),
      );

  Widget _buildHintBubble() => AnimatedOpacity(
        opacity: _hintIsVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Container(
          constraints: BoxConstraints(maxWidth: _getHintMessageWidth()),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _themeProvider.base06Color,
          ),
          child: Text(
            widget.hint,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: _themeProvider.textStyle(
              textStyle: TextStyles.caption,
              color: _themeProvider.base01Color,
            ),
          ),
        ),
      );

  Widget _buildUpperContent() => Builder(
        builder: (BuildContext context) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => _maxHeight = _getAvailableHeight() -
                (widget.upperContent == null ? 0.0 : context.size.height),
          );

          return Visibility(
            visible: widget.upperContent != null,
            child: widget.upperContent ?? Container(),
          );
        },
      );

  Widget _buildLowerContent() => Visibility(
        visible: widget.lowerContent != null,
        child: StreamBuilder<double>(
          stream: widget.controller.heightStream,
          initialData: widget.controller.height,
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) =>
              AnimatedContainer(
            curve: Curves.ease,
            duration: widget.changeStateDuration,
            height: snapshot.data,
            child: widget.lowerContent,
          ),
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
      if (widget.controller.height == 0) {
        dismiss();
      }

      close();
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

  double _getAppBarHeight() => Scaffold.of(context).hasAppBar
      ? Scaffold.of(context).appBarMaxHeight
      : 0.0;

  double _getDeviceHeight() => MediaQuery.of(context).size.height;

  double _getHintMessageWidth() => MediaQuery.of(context).size.width * 0.7;

  double _getTitleHeight() =>
      _togglerHeight + (widget.title == null ? 0.0 : 49.0);

  double _getAvailableHeight() =>
      _getDeviceHeight() - _getAppBarHeight() - _getTitleHeight();

  double _getHintTopPosition() => widget.controller.isOpened ? -8.0 : 28.0;

  double _getHintRightPosition() => widget.controller.isOpened ? 44.0 : 18.0;
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
