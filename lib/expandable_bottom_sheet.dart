import 'dart:async';

import 'package:flutter/material.dart';

class ExpandableBottomSheet extends StatefulWidget {
  // This controls the minimum height of the body. Must be greater or equal of
  // 0. By default is 0
  final double minHeight;
  final double maxHeight;

  // This controls the minimum height of the body. By default is 500

  // This is the content that will be hided of your bottomSheet. You can fit any
  // widget. This parameter is required
  final Widget upperBody;
  final Widget lowerBody;

  final bool hasTitle;
  final String title;
  final bool hasHint;
  final String hint;

  final Widget toggler;

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
    // @required this.context,
    @required this.upperBody,
    @required this.lowerBody,
    this.toggler,
    this.minHeight = 0,
    this.maxHeight,
    this.autoSwiped = true,
    this.canUserSwipe = true,
    this.maximizedAtStart = false,
    this.expandDuration = const Duration(milliseconds: 250),
    this.hasTitle = false,
    this.hasHint = false,
    this.title,
    this.hint,
    this.onShow,
    this.onHide,
  }) : super(key: key);

  @override
  _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  double _minHeight;
  double _maxHeight;
  bool _isDragDirectionUp;

  _ExpandableBottomSheetController _controller;

  @override
  void initState() {
    super.initState();

    if (_controller == null) {
      _controller = _ExpandableBottomSheetController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _minHeight = widget.minHeight;
    _maxHeight = _getAvailableHeight() - 76;

    _controller.height = widget.maximizedAtStart ? _maxHeight : _minHeight;

    _controller.value = widget.maximizedAtStart;

    _controller.addListener(() => _controller.value ? _show() : _hide());
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
            Visibility(
              visible: widget.hasTitle,
              child: _buildTitle(),
            ),
            widget.upperBody,
            _buildLowerBody(),
          ],
        ),
      );

  Widget _buildToggler() => GestureDetector(
        onVerticalDragUpdate:
            widget.canUserSwipe ? _onVerticalDragUpdate : null,
        onVerticalDragEnd: widget.autoSwiped ? _onVerticalDragEnd : null,
        child: widget.toggler ?? _getDefaultToggler(),
        onTap: _onTap,
      );

  Widget _buildTitle() => Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: <Widget>[
            Text(
              widget.title,
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
                onTap: () {},
              ),
              right: 18.0,
            )
          ],
        ),
      );

  Widget _getDefaultToggler() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          height: 4.0,
          width: 40.0,
          decoration: BoxDecoration(
            color: Color(0xFF3E3E3E),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      );

  Widget _buildLowerBody() => StreamBuilder<double>(
        stream: _controller.heightStream,
        initialData: _controller.height,
        builder: (BuildContext _, AsyncSnapshot snapshot) {
          return AnimatedContainer(
            curve: Curves.ease,
            duration: widget.expandDuration,
            height: snapshot.data,
            child: widget.lowerBody,
          );
        },
      );

  void _onTap() => _controller.value = _controller.height != _maxHeight;

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

    _controller.height = _minHeight;
  }

  void _onVerticalDragUpdate(DragUpdateDetails data) {
    if (((_controller.height - data.delta.dy) > _minHeight) &&
        ((_controller.height - data.delta.dy) < _maxHeight)) {
      _isDragDirectionUp = data.delta.dy <= 0;
      _controller.height -= data.delta.dy;
    }
  }

  void _onVerticalDragEnd(DragEndDetails data) {
    if (_isDragDirectionUp && (_controller?.value ?? false)) {
      _show();
    } else if (!(_isDragDirectionUp || _controller.value)) {
      _hide();
    } else {
      _controller.value = _isDragDirectionUp;
    }
  }

  double _getAppBarHeight() =>
      Scaffold.of(context).hasAppBar ? Scaffold.of(context).appBarMaxHeight : 0;

  double _getDeviceHeight() => MediaQuery.of(context).size.height;

  double _getAvailableHeight() =>
      _getDeviceHeight() - _getAppBarHeight() - 44 - 49;
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
