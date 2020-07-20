import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Expandable bottom sheet callback
typedef ExpandableBottomSheetCallback = void Function();

/// Expandable bottom sheet widget
class ExpandableBottomSheet extends StatefulWidget {
  /// Expandable bottom sheet controller
  final ExpandableBottomSheetController controller;

  /// Toggler widget
  /// Shows default toggler widget if [toggler] not set
  final Widget toggler;

  /// Upper content widget
  /// This part will be shown in closed and open state
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

  /// Change state animation duration
  final Duration changeStateDuration;

  /// [onOpen] callback
  /// This callback will be called when the expandable bottom sheet is open
  final ExpandableBottomSheetCallback onOpen;

  /// [onClose] callback
  /// This callback will be called when the expandable bottom sheet is close
  final ExpandableBottomSheetCallback onClose;

  /// [onDismiss] callback
  /// This callback will be called on the expandable bottom sheet dismiss
  final ExpandableBottomSheetCallback onDismiss;

  ExpandableBottomSheet({
    Key key,
    @required this.controller,
    this.upperContent,
    this.lowerContent,
    this.toggler,
    this.maxHeight,
    this.changeStateDuration = const Duration(milliseconds: 150),
    this.title,
    this.hint,
    this.onOpen,
    this.onClose,
    this.onDismiss,
  }) : super(key: key);

  @override
  _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  double _maxHeight;
  bool _isDragDirectionUp = false;
  bool _hintIsVisible = false;

  static final double _togglerHeight = 44.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.controller.height = 0;
    widget.controller.value = false;

    widget.controller
        .addListener(() => widget.controller.value ? _open() : _close());
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          color: Color(0xFF151717),
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
        child: widget.toggler ??
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 32.0,
              ),
              height: 4.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Color(0xFF3E3E3E),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
        onTap: _onTogglerTap,
      );

  Widget _buildTitleBar() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: <Widget>[
              if (widget.title != null) _buildTitle(),
              if (widget.hint != null)
                Positioned(
                  child: _buildInformationButton(),
                  right: 18.0,
                ),
              if (widget.hint != null)
                Positioned(
                  child: _buildHint(),
                  right: _getHintRightPosition(),
                  bottom: _getHintTopPosition(),
                ),
            ],
          ),
        ),
      );

  Widget _buildTitle() => Text(
        widget.title,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'IBMPlexSans',
          fontSize: 16.0,
        ),
      );

  Widget _buildInformationButton() => ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: Icon(
              Icons.info_outline,
              size: 20.0,
              color: Color(0xFFDADADA),
            ),
            onTap: () => setState(() => _hintIsVisible = !_hintIsVisible),
          ),
        ),
      );

  Widget _buildHint() => AnimatedOpacity(
        opacity: _hintIsVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 250),
        child: Container(
          constraints: BoxConstraints(maxWidth: _getHintMessageWidth()),
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Color(0xFF323738),
          ),
          child: Text(
            widget.hint,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
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
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              AnimatedContainer(
            curve: Curves.ease,
            duration: widget.changeStateDuration,
            height: snapshot.data,
            child: widget.lowerContent,
          ),
        ),
      );

  void _onTogglerTap() =>
      widget.controller.value = widget.controller.height != _maxHeight;

  void _onVerticalDragUpdate(DragUpdateDetails data) {
    if (widget.controller.height - data.delta.dy > 0 &&
        widget.controller.height - data.delta.dy < _maxHeight) {
      _isDragDirectionUp = data.delta.dy <= 0;
      widget.controller.height -= data.delta.dy;
    }
  }

  void _onVerticalDragEnd(DragEndDetails data) {
    if (_isDragDirectionUp && widget.controller.value) {
      _open();
    } else if (!(_isDragDirectionUp || widget.controller.value)) {
      if (widget.controller.height == 0) {
        dismiss();
      }

      _close();
    } else {
      widget.controller.value = _isDragDirectionUp;
    }
  }

  void _open() {
    if (widget.onOpen != null) {
      widget.onOpen();
    }

    widget.controller.height = _maxHeight;
  }

  void _close() {
    if (widget.onClose != null) {
      widget.onClose();
    }

    widget.controller.height = 0;
  }

  void dismiss() {
    if (widget.onDismiss != null) {
      widget.onDismiss();
    }

    widget.controller.height = 0;

    Navigator.pop(context);
  }

  double _getAppBarHeight() => Scaffold.of(context).hasAppBar
      ? Scaffold.of(context).appBarMaxHeight
      : 0.0;

  double _getDeviceHeight() => MediaQuery.of(context).size.height;

  double _getHintMessageWidth() => MediaQuery.of(context).size.width * 0.6;

  double _getTitleHeight() =>
      _togglerHeight + (widget.title == null ? 0.0 : 49.0);

  double _getAvailableHeight() =>
      _getDeviceHeight() - _getAppBarHeight() - _getTitleHeight();

  double _getHintTopPosition() => widget.controller.isOpened ? -6.0 : 28.0;

  double _getHintRightPosition() => widget.controller.isOpened ? 44.0 : 18.0;
}

class ExpandableBottomSheetController extends ValueNotifier<bool> {
  ExpandableBottomSheetController() : super(false);

  final ExpandableBottomSheetBloc _expandableBottomSheetBloc =
      ExpandableBottomSheetBloc();

  double _height;

  double get height => _height;

  set height(double value) =>
      _expandableBottomSheetBloc.dispatch(_height = value);

  Stream<double> get heightStream => _expandableBottomSheetBloc.height;

  Stream<bool> get isOpenStream => _expandableBottomSheetBloc.isOpen;

  bool get isOpened => value;

  void close() => value = false;

  void open() => value = true;

  @override
  void dispose() {
    _expandableBottomSheetBloc.dispose();

    super.dispose();
  }
}

class ExpandableBottomSheetBloc {
  final StreamController<double> _heightController =
      StreamController<double>.broadcast();
  final StreamController<bool> _visibilityController =
      StreamController<bool>.broadcast();

  Stream<double> get height => _heightController.stream;

  Stream<bool> get isOpen => _visibilityController.stream;

  void dispatch(double value) {
    _heightController.sink.add(value);
    _visibilityController.sink.add(value > 0);
  }

  void dispose() {
    _heightController.close();
    _visibilityController.close();
  }
}
