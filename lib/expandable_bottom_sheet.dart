import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_widget_test_playground/animated_message.dart';

class ExpandableBottomSheet extends StatefulWidget {
  // This controls the minimum height of the body. Must be greater or equal of
  // 0. By default is 0
  final double minHeight;
  final double maxHeight;

  // This controls the minimum height of the body. By default is 500

  // This is the content that will be hided of your bottomSheet. You can fit any
  // widget. This parameter is required
  final Widget upperContent;
  final Widget lowerContent;

  final String title;
  final String hint;

  final Widget togglerContent;

  // This flag is used to enable the automatic swipe of the bar. If it's true
  // the bottomSheet will automatically appear or disappear when user stops
  // swiping, but if it's false, it will stay at the last user finger position.
  // By default is true
  final bool autoSwiped;

  // This flag enable that users can swipe the header and hide or show the
  // solid bottom sheet. Turn on false if you don't want to let the user
  // interact with the solid bottom sheet. By default is true.
  final bool canUserSwipe; // TODO: Change to draggableHeader

  // This flag controls if the body is shown to the user by default. If it's
  // true, the body will be shown. If it's false the body will be hided. By
  // default it's false.
  final bool maximizedAtStart; // TODO: change to openedByDefault

  // This object used to control behavior internally
  // from the app and don't depend of user's interaction.
  // can hide and show  methods plus have isOpened variable
  // to check widget visibility on a screen

  // This method will be executed when the solid bottom sheet is completely
  // opened.
  final Function onShow;

  // This method will be executed when the solid bottom sheet is completely
  // closed.
  final Function onHide;

  // final BuildContext context;

  final Duration expandDuration;

  ExpandableBottomSheet({
    Key key,
    this.upperContent,
    this.lowerContent,
    this.togglerContent,
    this.minHeight = 0,
    this.maxHeight,
    this.autoSwiped = true,
    this.canUserSwipe = true,
    this.maximizedAtStart = false,
    this.expandDuration = const Duration(milliseconds: 250),
    this.title,
    this.hint,
    this.onShow,
    this.onHide,
  }) : super(key: key);

  @override
  _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  double _maxHeight;
  bool _isDragDirectionUp = false;
  bool _hintIsVisible = false;

  _ExpandableBottomSheetController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      _controller = _ExpandableBottomSheetController();
    }

    _controller.height =
        widget.maximizedAtStart ? _maxHeight : widget.minHeight;
    _controller.value = widget.maximizedAtStart;

    _controller.addListener(() => _controller.value ? _show() : _hide());
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.transparent,
        child: Container(
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
              _buildTitle(),
              _buildUpperContent(),
              _buildLowerContent(),
            ],
          ),
        ),
      );

  Widget _buildUpperContent() => Builder(
        builder: (BuildContext context) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => _maxHeight = _getAvailableHeight() -
                (widget.upperContent == null ? 4.0 : context.size.height),
          );

          return Visibility(
            visible: widget?.upperContent != null,
            child: widget.upperContent ?? Container(),
          );
        },
      );

  Widget _buildToggler() => Container(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate:
              widget.canUserSwipe ? _onVerticalDragUpdate : null,
          onVerticalDragEnd: widget.autoSwiped ? _onVerticalDragEnd : null,
          child: widget.togglerContent ?? _getDefaultToggler(),
          onTap: _onTogglerTap,
        ),
      );

  Widget _getDefaultToggler() => Container(
        margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        height: 4.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: Color(0xFF3E3E3E),
          borderRadius: BorderRadius.circular(4.0),
        ),
      );

  Widget _buildTitle() => Visibility(
    visible: widget.title != null,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: <Widget>[
          Text(
            widget.title ?? '',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'IBMPlexSans',
              fontSize: 16.0,
            ),
          ),
          Positioned(
            child: InkWell(
              child: Icon(
                Icons.info_outline,
                size: 20.0,
                color: Color(0xFFDADADA),
              ),
              onTap: () =>
                  setState(() => _hintIsVisible = !_hintIsVisible),
            ),
            right: 18.0,
          ),
          Positioned(
            child: Visibility(
              visible: _hintIsVisible,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 6.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Color(0xFF323738),
                ),
                child: AnimatedMessage(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 256,
                    ),
                    child: Text(
                      widget.hint ?? '',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            right: _getHintRightPosition(),
            bottom: _getHintTopPosition(),
          ),
        ],
      ),
    ),
  );

  Widget _buildLowerContent() => Visibility(
        visible: widget?.lowerContent != null,
        child: StreamBuilder<double>(
          stream: _controller.heightStream,
          initialData: _controller.height,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              AnimatedContainer(
            curve: Curves.ease,
            duration: widget.expandDuration,
            height: snapshot.data,
            child: widget.lowerContent,
          ),
        ),
      );

  void _onTogglerTap() => _controller.value = _controller.height != _maxHeight;

  void _show() {
    if (widget.onShow != null) {
      widget.onShow();
    }

    _controller.height = _maxHeight;
  }

  void _hide() {
    if (widget.onHide != null) {
      widget.onHide();
    }

    _controller.height = widget.minHeight;
  }

  void _onVerticalDragUpdate(DragUpdateDetails data) {
    if (_controller.height - data.delta.dy > widget.minHeight &&
        _controller.height - data.delta.dy < _maxHeight) {
      _isDragDirectionUp = data.delta.dy <= 0;
      _controller.height = _maxHeight;
    }
  }

  void _onVerticalDragEnd(DragEndDetails data) {
    if (_isDragDirectionUp && _controller.value) {
      _show();
    } else if (!(_isDragDirectionUp || _controller.value)) {
      if (_controller.height == 0) {
        close();
      }

      _hide();
    } else {
      _controller.value = _isDragDirectionUp;
    }
  }

  void close() {
    _hide();

    Navigator.pop(context);
  }

  double _getAppBarHeight() => Scaffold.of(context).hasAppBar
      ? Scaffold.of(context).appBarMaxHeight
      : 0.0;

  double _getDeviceHeight() => MediaQuery.of(context).size.height;

  double _getTitleHeight() => 44.0 + (widget.title != null ? 49.0 : 0.0);

  double _getAvailableHeight() =>
      _getDeviceHeight() - _getAppBarHeight() - _getTitleHeight();

  double _getHintTopPosition() => _controller.isOpened ? -6.0 : 28.0;

  double _getHintRightPosition() => _controller.isOpened ? 44.0 : 18.0;
}

class _ExpandableBottomSheetBloc {
  final StreamController<double> _heightController =
      StreamController<double>.broadcast();
  final StreamController<bool> _visibilityController =
      StreamController<bool>.broadcast();

  Stream<double> get height => _heightController.stream;

  Stream<bool> get isOpen => _visibilityController.stream;

  // Adds new values to streams
  void dispatch(double value) {
    _heightController.sink.add(value);
    _visibilityController.sink.add(value > 0);
  }

  // Closes streams
  void dispose() {
    _heightController.close();
    _visibilityController.close();
  }
}

class _ExpandableBottomSheetController extends ValueNotifier<bool> {
  _ExpandableBottomSheetController() : super(false);

  final _ExpandableBottomSheetBloc _expandableBottomSheetBloc =
      _ExpandableBottomSheetBloc();

  double _height;

  double get height => _height;

  set height(double value) =>
      _expandableBottomSheetBloc.dispatch(_height = value);

  Stream<double> get heightStream => _expandableBottomSheetBloc.height;

  Stream<bool> get isOpenStream => _expandableBottomSheetBloc.isOpen;

  bool get isOpened => value;

  void hide() => value = false;

  void show() => value = true;

  @override
  void dispose() {
    _expandableBottomSheetBloc.dispose();

    super.dispose();
  }
}
